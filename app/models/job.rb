class Job < ApplicationRecord
    include Slugifiable::InstanceMethods

    belongs_to :company
    belongs_to :provider, optional: true
    belongs_to :country, optional: true
    has_many :user_jobs
    has_many :users, through: :user_jobs
    has_many :applications

    def self.find_or_create_by_attributes_hash(attributes_hash)
        # find or create the company
        company = Company.find_or_create_by(name: attributes_hash[:company_name])

        # remove company from the attributes hash then create an associated job using the remaining attributes hash
        attributes_hash.delete(:company_name)
        company.jobs.find_or_create_by(attributes_hash)
    end

    def self.find_or_create_by_attributes_hash_with_user(attributes, user)
        job = Job.find_or_create_by_attributes_hash(attributes)
        UserJob.find_or_create_by(user_id: user.id, job_id: job.id)
        job
    end

    def company_name=(name)
        self.company = Company.find_or_create_by(name: name)
    end

    def company_name
        self.company.try(:name)
    end

    def provider_job_url
        country_id = self.country_id || 59
        base_show_url = self.provider.base_show_url_by_country(country_id)
        slug = self.provider_job_slug.try("+", "/") || ""
        base_show_url + slug + self.provider_job_id
    end

    def url
        self.custom_url || self.provider_job_url
    end

    def user_generated?
        !self.provider_id
    end
end
