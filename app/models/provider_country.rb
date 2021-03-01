class ProviderCountry < ApplicationRecord
    belongs_to :provider
    belongs_to :country
end
