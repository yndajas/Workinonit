class UserJob < ApplicationRecord
    belongs_to :user
    belongs_to :job

    scope :user, ->(user) {where(user_id: user.id)}
    scope :job, ->(job) {where(job_id: job.id)}

    def self.by_user_reverse_chronological(user)
        self.user(user).order(created_at: :desc)
    end

    def self.by_user_and_company_reverse_chronological(user, company)
        self.by_user_reverse_chronological(user).collect do |user_job|
            user_job if user_job.company == company
        end.compact
    end

    def self.unapplied_by_user_reverse_chronological(user)
        self.by_user_reverse_chronological(user).collect do |user_job|
            user_job if Application.user_job(user_job).length == 0
        end.compact
    end

    def company
        self.job.company
    end
end
