class User < ApplicationRecord
    has_many :user_jobs
    has_many :jobs, through: :user_jobs
    has_many :companies, through: :jobs
    has_many :user_company_information
    has_many :applications
    has_secure_password

    def companies_alphabetical
        self.companies.order(:name)
    end
end
