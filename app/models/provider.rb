class Provider < ApplicationRecord
    has_many :jobs
    has_many :provider_countries
    has_many :countries, through: :provider_countries

    def base_show_url_by_country(country_id = 59)
        # if the provider is Indeed and the country isn't the UK
        if self.name == "Indeed" && country_id != 59
            # if the country is USA
            if country_id == 60
                self.base_show_url.gsub("uk.", "")
            # any other country
            else
                country_code = ProviderCountry.find_by(provider_id: self.id, country_id: country_id).code
                self.base_show_url.gsub("uk", country_code)
            end
        # Indeed UK and all other providers
        else
            self.base_show_url
        end
    end
end
