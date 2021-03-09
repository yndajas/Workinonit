class UserJob < ApplicationRecord
    extend Findable::ClassMethods

    belongs_to :user
    belongs_to :job

    scope :user, ->(user) {where(user_id: user.id)}
    scope :job, ->(job) {where(job_id: job.id)}

    def self.find_by_user_and_unapplied_reverse_by_date(user, date)
        self.find_by_user_reverse_by_date(user, date).collect do |user_job|
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
