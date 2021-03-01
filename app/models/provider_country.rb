class ProviderCountry < ApplicationRecord
    belongs_to :provider
    belongs_to :country

    def country_name
        self.country.name
    end
end
