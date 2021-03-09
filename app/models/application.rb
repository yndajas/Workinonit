class Application < ApplicationRecord
    include Attributable::InstanceMethods
    include FormatAndSanitizable::InstanceMethods

    belongs_to :user
    belongs_to :job
    belongs_to :status

    scope :user_job, ->(user_job) {where(user_id: user_job.user_id, job_id: user_job.job_id)}

    def self.find_by_user_job(user_job)
        self.user_job(user_job)[0]
    end
end
