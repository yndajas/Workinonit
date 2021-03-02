class JobScraper
    def self.scrape_search(keywords, location, country_id = 59)
        {Indeed: scrape_indeed_search(keywords, location, country_id), LinkedIn: scrape_linkedin_search(keywords, location), Reed: scrape_reed_search(keywords, location)}
    end

    def self.scrape_jobs_by_id_hash(hash)
        # for all the providers in the hash
        hash.keys.collect do |provider|
            # iterate over the IDs from that provider
            hash[provider].collect do |id|
                # scrape attrbutes and return hash for each
                self.send("scrape_#{provider.downcase}_job", id)
            end
        end.flatten # flatten resulting collection of attributes hashes and return 
    end

    def self.scrape_job_by_url(url)
        # add https:// to the start if there's no 'scheme' (http or https)
        url = "https://#{url}" if URI.parse(url).scheme.nil?

        # check the host is *indeed.com, *linkedin.com or *reed.co.uk, return error message if not
        valid_host = valid_host(url)
        if valid_host
            # try to open page, return error message if it's a 404
            page = valid_page(url)
            if page
                case valid_host
                when "Indeed"
                    scrape_indeed_job_page(page)
                when "LinkedIn"
                    scrape_linkedin_job_page(page)
                when "Reed"
                    scrape_reed_job_page(page)
                end
            else
                "Unable to scrape job - page not found"
            end
        else
            "URL not recognised. Only indeed.com, linkedin.com and reed.co.uk URLs are supported"
        end
    end

    private

    # scrape specific provider search pages

    def self.scrape_indeed_search(keywords, location, country_id)
        # set base URL based on country
        if country_id == 60 # if country is USA
            base_url = "https://indeed.com/"
        else
            base_url = "https://" + ProviderCountry.find_by(country_id: country_id).code + ".indeed.com/"
        end

        # open search page
        search = Nokogiri::HTML(OpenURI.open_uri(base_url + keywords + "-jobs-in-" + location))

        # select jobs; limit to first 5
        first_five_jobs = search.css("div.jobsearch-SerpJobCard")[0..4]

        # iterate over jobs, collecting each job's attributes in a hash, then return an array of the hashes
        first_five_jobs.collect do |job|
            title = job.css("a.jobtitle").attribute("title").value
            company = job.css("span.company").text.strip
            id = job.attribute("data-jk").value

            {title: title, company: company, id: id}
        end
    end

    def self.scrape_linkedin_search(keywords, location)
        # open search page
        search = Nokogiri::HTML(OpenURI.open_uri("https://www.linkedin.com/jobs/" + keywords + "-jobs-" + location))

        # select jobs; limit to first 5
        first_five_jobs = search.css("li.result-card")[0..4]

        # iterate over jobs, collecting each job's attributes in a hash, then return an array of the hashes
        first_five_jobs.collect do |job|
            title = job.css("h3.result-card__title").text
            company = job.css("h4.result-card__subtitle").text
            id = job.attribute("data-id").value

            {title: title, company: company, id: id}
        end
    end

    def self.scrape_reed_search(keywords, location)
        # open search page
        search = Nokogiri::HTML(OpenURI.open_uri("https://www.reed.co.uk/jobs/" + keywords + "-jobs-in-" + location))

        # select jobs; limit to first 5
        first_five_jobs = search.css("article.job-result")[0..4]

        # iterate over jobs, collecting each job's attributes in a hash, then return an array of the hashes
        first_five_jobs.collect do |job|
            title_id = job.css("h3.title a")
            title = title_id.attribute("title").value
            id = title_id.attribute("data-id").value
            company = job.css("a.gtmJobListingPostedBy").text

            {title: title, company: company, id: id}
        end
    end

    # scrape by URL helpers

    ## valid URL/page checkers

    def self.valid_host(url)
        host = URI.parse(url).host.downcase
        if host.include?("indeed.com")
            "Indeed"
        elsif host.include?("linkedin.com")
            "LinkedIn"
        elsif host.include?("reed.co.uk")
            "Reed"
        else
            false
        end
    end

    def self.valid_page(url)
        begin 
            Nokogiri::HTML(OpenURI.open_uri(url))
        rescue
            false
        end
    end    

    ## check if provider page is a valid job listing page, get id and/or slug and send to scraper if so

    def self.scrape_indeed_job_page(page)
        # attempt to locate meta tag that appears on genuine job listing pages
        share_url_meta_tag = page.css("meta#indeed-share-url")

        # if found, get the provider's ID for the job, else return an error message
        if share_url_meta_tag.length > 0
            id = share_url_meta_tag.attribute("content").value.gsub(/.*jk\=/, "")
            scrape_indeed_job(id)
        else
            "Unable to scrape job from Indeed - ensure the URL is for an individual job, not search results"
        end
    end

    def self.scrape_linkedin_job_page(page)
        # attempt to locate code tag that appears on genuine job listing pages (and search results pages with a job selected - the method works for both)
        id_comment_code_tag = page.css("code#decoratedJobPostingId")

        # if found, get the provider's ID for the job, else return an error message
        if id_comment_code_tag.length > 0
            id = id_comment_code_tag.inner_html.gsub(/[^0-9]+/i, "")
            scrape_linkedin_job(id)
        else
            "Unable to scrape job from LinkedIn - ensure the URL is for an individual job (either a job-specific page or search results with the job selected)"
        end
    end

    def self.scrape_reed_job_page(page)
        # attempt to locate input tag that appears on genuine job listing pages
        id_input_tag = page.css("input#JobId")

        # if found, get the provider's ID for the job, else return an error message
        if id_input_tag.length > 0
            id = id_input_tag.attribute("value").value
            scrape_reed_job(id)
        else
            "Unable to scrape job from Reed - ensure the URL is for a job"
        end
    end

    ## scrape job listing pages

    def self.scrape_indeed_job(id)
        provider = Provider.find_by(name: "Indeed")

        page = show_page(provider, id)

        true
    end

    def self.scrape_linkedin_job(id)
        provider = Provider.find_by(name: "LinkedIn")

        page = show_page(provider, id)

        true
    end

    def self.scrape_reed_job(id)        
        provider = Provider.find_by(name: "Reed")

        # prepare a URL that will lead to the job's show page
        # while Reed's slug is in the model/database table and collected below,
        # the part of the path that contains the slug can actually contain
        # (seemingly) any text, so long as it contains something, so here "j/"
        # is used for all jobs in place of the slug for simplicity
        page = show_page(provider, id, "j/")

        # get company name to be used in find_or_create_by
        company_name = page.css("span[itemprop='hiringOrganization'] span[itemprop='name']").text

        # get remaining job attributes for creating new job associated with company
        title = page.css("h1").text
        location = page.css("span[itemprop='addressLocality']").text
        salary = page.css("span[data-qa='salaryLbl']").text
        contract = page.css("span[itemprop='employmentType']").text

        # t.text "description"
        description = page.css("span[itemprop='description']").inner_html

        # collect slug to create links in the same style as Reed, even though the value makes no difference to their routing
        slug_link_tag = page.css("div.description-container meta[itemprop='url']").attribute("content")
        provider_job_slug = slug_link_tag.value.gsub(/\/#{id}/, "").gsub(/.*\//, "")
        
        provider_job_id = id
        provider_id = provider.id

        {company_name: company_name, title: title, location: location, salary: salary, contract: contract, description: description, provider_job_slug: provider_job_slug, provider_job_id: provider_job_id, provider_id: provider_id}
    end

    def self.show_page(provider, id, slug = "")
        url = provider.base_show_url + slug + id
        Nokogiri::HTML(OpenURI.open_uri(url))
    end
end