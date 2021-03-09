class User < ApplicationRecord
    has_many :user_jobs
    has_many :jobs, through: :user_jobs
    has_many :user_company_information
    has_many :applications
    has_secure_password

    def companies
        self.jobs.collect { |job| job.company }.uniq
    end

    def companies_alphabetical
        self.companies.sort_by(&:name)
    end

    def companies_with_applications
        self.jobs.collect do |job|
            user_job = UserJob.find_by_user_and_job(self, job)
            job.company if Application.find_by_user_job(user_job)
        end.compact.uniq
    end

    def companies_with_applications_alphabetical
        self.companies_with_applications.sort_by(&:name)
    end
end
