class Country < ApplicationRecord
    has_many :provider_countries
    has_many :providers, through: :provider_countries
end
