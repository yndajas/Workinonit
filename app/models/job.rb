class Job < ApplicationRecord
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    belongs_to :company
    belongs_to :provider
    belongs_to :country, optional: true
    has_many :user_jobs
    has_many :users, through: :user_jobs

    def self.find_or_create_by_scraped_attributes(attributes)
        # find or create the company
        company = Company.find_or_create_by(name: attributes[:company_name])

        # remove company from the attributes hash then create an associated job using the remaining attributes hash
        attributes.delete(:company_name)
        company.jobs.find_or_create_by(attributes)
    end

    def self.find_or_create_by_scraped_attributes_with_user(attributes, user)
        job = Job.find_or_create_by_scraped_attributes(attributes)
        UserJob.find_or_create_by(user_id: user.id, job_id: job.id)
        job
    end

    def provider_job_url
        country_id = self.country_id || 59
        base_show_url = self.provider.base_show_url_by_country(country_id)
        slug = self.provider_job_slug.try("+", "/") || ""
        base_show_url + slug + self.provider_job_id
    end
end
