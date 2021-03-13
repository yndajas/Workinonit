class JobScraper
    def self.scrape_search(keywords, location, country_id = 59)
        {Indeed: scrape_indeed_search(keywords, location, country_id), LinkedIn: scrape_linkedin_search(keywords, location), Reed: scrape_reed_search(keywords, location)}
    end

    def self.scrape_jobs_by_id_hash(hash, country_id = 59)
        # for all the providers in the hash
        hash.keys.collect do |provider|
            # iterate over the IDs from that provider
            hash[provider].collect do |id|
                # scrape attrbutes and return hash for each; if provider is Indeed, pass in country ID
                if provider == "Indeed"
                    scrape_indeed_job(id, country_id)
                else
                    self.send("scrape_#{provider.downcase}_job", id)
                end
            end.compact # get rid of nils if the job was unscrapable
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
                    # get country
                    scheme_and_code = url.gsub(/indeed\.com.*/, "").gsub(".", "")
                    code = scheme_and_code.gsub(/.*\/\//, "").gsub("www", "")
                    if code == ""
                        country_id = 60
                    else
                        country_id = ProviderCountry.find_by(code: code).country_id
                    end
                    scrape_indeed_job_page(page, country_id) || "Unable to scrape job - request denied by provider"
                when "LinkedIn"
                    scrape_linkedin_job_page(page) || "Unable to scrape job - request denied by provider"
                when "Reed"
                    scrape_reed_job_page(page) || "Unable to scrape job - request denied by provider"
                end
            else
                "Unable to scrape job - page not found or request denied by provider"
            end
        else
            "URL not recognised. Only indeed.com, linkedin.com and reed.co.uk URLs are supported"
        end
    end

    private

    # scrape specific provider search pages

    def self.scrape_indeed_search(keywords, location, country_id)
        # get search URL
        url = indeed_search_url(keywords, location, country_id)

        page = valid_page(url)

        if page
            # open search page
            search = Nokogiri::HTML(open(url))

            # select jobs; limit to first 5
            first_five_jobs = search.css("div.jobsearch-SerpJobCard")[0..4]

            # iterate over jobs, collecting each job's attributes in a hash, then return an array of the hashes
            first_five_jobs.collect do |job|
                title = job.css("a.jobtitle").attribute("title").value
                company = job.css("span.company").text.strip
                id = job.attribute("data-jk").value

                {title: title, company: company, id: id}
            end
        else
            []
        end
    end

    def self.scrape_linkedin_search(keywords, location)
        # get search URL
        url = linkedin_search_url(keywords, location)

        page = valid_page(url)

        if page
            # open search page
            search = Nokogiri::HTML(open(url))

            # select jobs; limit to first 5
            first_five_jobs = search.css("li.result-card")[0..4]

            # iterate over jobs, collecting each job's attributes in a hash, then return an array of the hashes
            first_five_jobs.collect do |job|
                title = job.css("h3.result-card__title").text
                company = job.css("h4.result-card__subtitle").text
                id = job.attribute("data-id").value

                {title: title, company: company, id: id}
            end
        else
            []
        end
    end

    def self.scrape_reed_search(keywords, location)
        # get search URL
        url = reed_search_url(keywords, location)

        page = valid_page(url)

        if page
            # open search page
            search = Nokogiri::HTML(open(url))

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
        else
            []
        end
    end

    def self.indeed_search_url(keywords, location, country_id)
        # set base URL based on country
        if country_id == 60 # if country is USA
            base_url = "https://indeed.com/"
        else
            base_url = "https://" + ProviderCountry.find_by(country_id: country_id).code + ".indeed.com/"
        end

        base_url + keywords + "-jobs-in-" + location        
    end

    def self.linkedin_search_url(keywords, location)
        "https://www.linkedin.com/jobs/" + keywords + "-jobs-" + location
    end

    def self.reed_search_url(keywords, location)
        "https://www.reed.co.uk/jobs/" + keywords + "-jobs-in-" + location
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
            Nokogiri::HTML(open(url))
        rescue
            false
        end
    end    

    ## check if provider page is a valid job listing page, get id and/or slug and send to scraper if so

    def self.scrape_indeed_job_page(page, country_id = 59)
        # attempt to locate meta element that appears on genuine job listing pages
        share_url_meta_element = page.css("meta#indeed-share-url")

        # if found, get the provider's ID for the job, else return an error message
        if share_url_meta_element.length > 0
            id = share_url_meta_element.attribute("content").value.gsub(/.*jk\=/, "")
            scrape_indeed_job(id, country_id)
        else
            "Unable to scrape job from Indeed - ensure the URL is for an individual job, not search results"
        end
    end

    def self.scrape_linkedin_job_page(page)
        # attempt to locate code element that appears on genuine job listing pages (and search results pages with a job selected - the method works for both)
        id_comment_code_element = page.css("code#decoratedJobPostingId")

        # if found, get the provider's ID for the job, else return an error message
        if id_comment_code_element.length > 0
            id = id_comment_code_element.inner_html.gsub(/[^0-9]+/i, "")
            scrape_linkedin_job(id)
        else
            "Unable to scrape job from LinkedIn - ensure the URL is for an individual job (either a job-specific page or search results with the job selected)"
        end
    end

    def self.scrape_reed_job_page(page)
        # attempt to locate input element that appears on genuine job listing pages
        id_input_element = page.css("input#JobId")

        # if found, get the provider's ID for the job, else return an error message
        if id_input_element.length > 0
            id = id_input_element.attribute("value").value
            scrape_reed_job(id)
        else
            "Unable to scrape job from Reed - ensure the URL is for a job"
        end
    end

    ## scrape job listing pages

    def self.scrape_indeed_job(id, country_id = 59)
        provider = Provider.find_by(name: "Indeed")

        page = valid_show_page(provider, id, country_id: country_id)

        if page
            company_and_location_div_element = page.css("div.jobsearch-CompanyInfoWithoutHeaderImage div div")

            # get company name to be used in find_or_create_by
            company_name = company_and_location_div_element.css("div div.icl-u-lg-mr--sm.icl-u-xs-mr--xs").text.strip

            # get remaining job attributes for creating new job associated with company
            title = page.css("h1.jobsearch-JobInfoHeader-title").text
            location = company_and_location_div_element.css("div.jobsearch-InlineCompanyRating + div").text.strip

            # this seems unnecessary and doesn't work for US pages, so commenting out (including the corresponding parts of the if block below) but leaving it here for now
            # salary_and_contract_div_element = page.css("div.jobsearch-JobMetadataHeader-item")
            # if salary_and_contract_div_element.length > 0
                # salary_span_element = salary_and_contract_div_element.css("span.icl-u-xs-mr--xs")
                # contract_span_element = salary_and_contract_div_element.css("span.jobsearch-JobMetadataHeader-item")
            # end

            salary_span_element = page.css("span.icl-u-xs-mr--xs")
            salary = salary_span_element.text.strip if salary_span_element.length > 0
            
            # UK and maybe all non-US versions of the site?
            contract_span_element = page.css("span.jobsearch-JobMetadataHeader-item")
            # US version
            contract_parent_div_element = page.css("div.jobsearch-JobDescriptionSection-sectionItem:nth-child(3)")

            # if UK/all non-US?
            if contract_span_element.length > 0
                contract = contract_span_element.text.gsub(" - ", "").strip
            # if US
            elsif contract_parent_div_element.length > 0
                contract_child_div_elements = contract_parent_div_element.css("div div")[1..-1]
                contract = contract_child_div_elements.collect { |div| div.text.strip }.join(", ")
            end

            description = page.css("div#jobDescriptionText").inner_html.strip
            provider_job_id = id
            provider_id = provider.id
        
            {company_name: company_name, title: title, location: location, salary: salary, contract: contract, description: description, provider_job_id: provider_job_id, provider_id: provider_id, country_id: country_id}
        else
            nil
        end
    end

    def self.scrape_linkedin_job(id)
        provider = Provider.find_by(name: "LinkedIn")

        page = valid_show_page(provider, id)

        if page
            # get company name to be used in find_or_create_by
            company_name = page.css("span.topcard__flavor:not(.topcard__flavor--bullet)").text.strip

            # get remaining job attributes for creating new job associated with company
            title = page.css("h1.topcard__title").text.strip
            location = page.css("span.topcard__flavor.topcard__flavor--bullet").text.strip

            salary_div_element = page.css("div.compensation__salary")
            salary = salary_div_element.text.strip if salary_div_element.length > 0

            contract = page.css("li.job-criteria__item:nth-child(2) span").text.strip
            description = page.css("div.show-more-less-html__markup").inner_html.strip
            provider_job_id = id
            provider_id = provider.id
        
            {company_name: company_name, title: title, location: location, salary: salary, contract: contract, description: description, provider_job_id: provider_job_id, provider_id: provider_id}
        else
            nil
        end
    end

    def self.scrape_reed_job(id)        
        provider = Provider.find_by(name: "Reed")

        # prepare a URL that will lead to the job's show page
        # while Reed's slug is in the model/database table and collected below,
        # the part of the path that contains the slug can actually contain
        # (seemingly) any text, so long as it contains something, so here "j/"
        # is used for all jobs in place of the slug for simplicity
        page = valid_show_page(provider, id, slug: "j/")

        if page
            # get company name to be used in find_or_create_by
            company_name = page.css("span[itemprop='hiringOrganization'] span[itemprop='name']").text.strip

            # get remaining job attributes for creating new job associated with company
            title = page.css("h1").text.strip
            location = page.css("span[itemprop='addressLocality']").text.strip
            salary = page.css("span[data-qa='salaryLbl']").text.strip
            contract = page.css("span[itemprop='employmentType']").text.strip
            description = page.css("span[itemprop='description']").inner_html.strip

            # collect slug to create links in the same style as Reed, even though the value makes no difference to their routing
            slug_link_element = page.css("div.description-container meta[itemprop='url']").attribute("content")
            provider_job_slug = slug_link_element.value.gsub(/\/#{id}/, "").gsub(/.*\//, "")
            
            provider_job_id = id
            provider_id = provider.id

            {company_name: company_name, title: title, location: location, salary: salary, contract: contract, description: description, provider_job_slug: provider_job_slug, provider_job_id: provider_job_id, provider_id: provider_id}
        else
            nil
        end
    end

    def self.valid_show_page(provider, id, slug: "", country_id: 59)
        base_show_url = provider.base_show_url_by_country(country_id)
        url = base_show_url + slug + id
        valid_page(url)
    end

    def self.open(url)
        OpenURI.open_uri(url, "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36")
    end
end