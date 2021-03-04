class Company < ApplicationRecord
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
    
    has_many :jobs
    has_many :users, through: :jobs
end