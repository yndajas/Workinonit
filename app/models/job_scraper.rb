class JobScraper
    def self.scrape_search(location, keywords)
        # mass assignment method for slugification - more DRY but more code
        # bind = binding
        # {location: location, keywords: keywords}.each {|arg, value| bind.local_variable_set(:"#{arg}", Slugifiable::slugify(value))}

        location = Slugifiable::slugify(location)
        keywords = Slugifiable::slugify(keywords)
        
        {Indeed: scrape_indeed_search(location, keywords), LinkedIn: scrape_linkedin_search(location, keywords), Reed: scrape_reed_search(location, keywords)}
    end
end