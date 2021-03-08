class Company < ApplicationRecord
    extend Findable::ClassMethods
    include Slugifiable::InstanceMethods
    
    has_many :jobs
    has_many :user_jobs, through: :jobs
    has_many :applications, through: :jobs
    has_many :user_company_information
end