class JobScraper
    def self.scrape_search(location, keywords)
        # mass assignment method for slugification - more DRY but more code
        # bind = binding
        # {location: location, keywords: keywords}.each {|arg, value| bind.local_variable_set(:"#{arg}", Slugifiable::slugify(value))}

        location = Slugifiable::slugify(location)
        keywords = Slugifiable::slugify(keywords)
        
        {Indeed: scrape_indeed_search(location, keywords), LinkedIn: scrape_linkedin_search(location, keywords), Reed: scrape_reed_search(location, keywords)}
    end
    
    def self.scrape_linkedin_search(location, keywords)
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

    def self.scrape_reed_search(location, keywords)
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