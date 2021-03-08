class Company < ApplicationRecord
    include Slugifiable::InstanceMethods
    
    has_many :jobs
    has_many :users, through: :jobs
    has_many :applications, through: :jobs
    has_many :user_company_information

    scope :id, ->(id) {where(id: id)}


    def self.find_by_id(id)
        self.id(id)[0]
    end
end