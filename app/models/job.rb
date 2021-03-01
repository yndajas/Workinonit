class Job < ApplicationRecord
    belongs_to :company
    belongs_to :provider
    has_many :user_jobs
    has_many :users, through: :user_jobs
end
