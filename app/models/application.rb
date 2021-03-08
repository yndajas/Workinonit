class Application < ApplicationRecord
    belongs_to :user
    belongs_to :job
    belongs_to :status

    scope :user_job, ->(user_job) {where(user_id: user_job.user_id, job_id: user_job.job_id)}
end
