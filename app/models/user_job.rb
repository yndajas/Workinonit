class UserJob < ApplicationRecord
    belongs_to :user
    belongs_to :job

    scope :user, ->(user) {where(user_id: user.id)}
    scope :job, ->(job) {where(job_id: job.id)}

    def self.find_by_user_reverse_chronological(user)
        self.user(user).order(created_at: :desc)
    end

    def self.find_by_user_and_company_reverse_chronological(user, company)
        self.find_by_user_reverse_chronological(user).collect do |user_job|
            user_job if user_job.company == company
        end.compact
    end

    def self.find_by_user_and_unapplied_reverse_chronological(user)
        self.find_by_user_reverse_chronological(user).collect do |user_job|
            user_job if !Application.find_by_user_job(user_job)
        end.compact
    end

    def self.find_by_job(job)
        self.job(job)[0]
    end

    def self.find_by_user_and_job(user, job)
        self.user(user).job(job)[0]
    end

    def company
        self.job.company
    end

    def application
        Application.find_by_user_job(self)
    end
end
