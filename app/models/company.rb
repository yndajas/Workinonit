class Company < ApplicationRecord
    include Slugifiable::InstanceMethods
    
    has_many :jobs
    has_many :users, through: :jobs
    has_many :applications, through: :jobs
    has_many :user_company_information
end