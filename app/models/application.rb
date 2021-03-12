class Application < ApplicationRecord
    extend Findable::ClassMethods
    include Attributable::InstanceMethods
    include FormatAndSanitizable::InstanceMethods

    belongs_to :user
    belongs_to :job
    belongs_to :status

    scope :user, ->(user) {where(user_id: user.id)}
    scope :user_job, ->(user_job) {where(user_id: user_job.user_id, job_id: user_job.job_id)}
    
    def self.find_by_user_job(user_job)
        self.user_job(user_job)[0]
    end

    def self.find_by_user_and_status_reverse_by_date(user, status, date)
        self.find_by_user_reverse_by_date(user, date).collect do |application|
            application if application.status == status
        end.compact
    end

    def self.find_by_user_and_open_reverse_by_date(user, date)
        self.find_by_user_reverse_by_date(user, date).collect do |application|
            application if (1..5).to_a.<<(7).include?(application.status_id)
        end.compact
    end

    def self.find_by_user_reverse_by_date_with_feedback(user, date)
        self.find_by_user_reverse_by_date(user, date).collect do |application|
            application if application.has_value_for?(:feedback)
        end.compact
    end

    def self.find_by_user_and_company_reverse_by_date_with_feedback(user, company, date)
        self.find_by_user_and_company_reverse_by_date(user, company, date).collect do |application|
            application if application.has_value_for?(:feedback)
        end.compact
    end

    def self.find_unsuccessful_by_user_without_feedback_alphabetical(user)
        Application.user(user).collect do |application|
            application if !application.has_value_for?(:feedback) && application.status_id == 6
        end.compact.sort_by(&:job_title)
    end

    def job_title
        self.job.title
    end

    def job_title_and_company
        self.job.title_and_company
    end

    def job_slug
        self.job.slug
    end

    def company
        self.job.company
    end

    def company_name
        self.job.company_name
    end

    def location
        self.job.location
    end

    def status_name
        self.status.name
    end
end
