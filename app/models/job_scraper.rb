class JobScraper
    def self.scrape_search(keywords, location, country_id = 59)
        # mass assignment method for slugification - more DRY but more code
        # bind = binding
        # {location: location, keywords: keywords}.each {|arg, value| bind.local_variable_set(:"#{arg}", Slugifiable::slugify(value))}

        location = Slugifiable::slugify(location)
        keywords = Slugifiable::slugify(keywords)
        
        {Indeed: scrape_indeed_search(keywords, location, country_id), LinkedIn: scrape_linkedin_search(keywords, location), Reed: scrape_reed_search(keywords, location)}
    end

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
            title_id = job.css("a.jobtitle")
            title = title_id.attribute("title").value
            id = title_id.attribute("id").value.gsub("jl_", "")
            company = job.css("span.company").text.strip

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
end