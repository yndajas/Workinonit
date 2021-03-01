class Provider < ApplicationRecord
    has_many :jobs
    has_many :provider_countries
    has_many :providers, through: :provider_countries
end
