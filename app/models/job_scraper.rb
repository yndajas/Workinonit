class JobScraper
    def self.scrape_search(keywords, location, country_id = 59)
        {Indeed: scrape_indeed_search(keywords, location, country_id), LinkedIn: scrape_linkedin_search(keywords, location), Reed: scrape_reed_search(keywords, location)}
    end

    def self.scrape_job_by_url(url)
        # add https:// to the start if there's no 'scheme' (http or https)
        url = "https://#{url}" if URI.parse(url).scheme.nil?

        valid_host = valid_host(url)
        if valid_host
            case valid_host
            when "Indeed"
                scrape_indeed_job_by_url(url)
            when "LinkedIn"
                scrape_linkedin_job_by_url(url)
            when "Reed"
                scrape_reed_job_by_url(url)
            end
        else
            "URL not recognised. Only indeed.com, linkedin.com and reed.co.uk URLs are supported"
        end
    end

    private

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
            title_slug_id = job.css("h3.title a")
            title = title_slug_id.attribute("title").value
            id = title_slug_id.attribute("data-id").value
            slug = title_slug_id.attribute("href").value.gsub("/jobs/", "").gsub(/\/#{id}.*/, "")
            company = job.css("a.gtmJobListingPostedBy").text

            {title: title, company: company, slug: slug, id: id}
        end
    end

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

    def self.scrape_indeed_job_by_url(url)
        # open job listing page
        listing = Nokogiri::HTML(OpenURI.open_uri(url))
        share_url_meta_tag = listing.css("meta#indeed-share-url")
        if share_url_meta_tag.length > 0
            id = share_url_meta_tag.attribute("content").value.gsub(/.*jk\=/, "")
            scrape_indeed_job(id)
        else
            "Unable to scrape job from Indeed - ensure the URL is an individual job, not search results"
        end
    end

    def self.scrape_linkedin_job_by_url(url)
        true
    end

    def self.scrape_reed_job_by_url(url)
        true
    end

    def self.scrape_indeed_job(id)
        true
    end
end