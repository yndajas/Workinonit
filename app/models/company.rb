class Company < ApplicationRecord
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
    
    has_many :jobs
end