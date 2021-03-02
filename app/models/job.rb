class Job < ApplicationRecord
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    belongs_to :company
    belongs_to :provider
    has_many :user_jobs
    has_many :users, through: :user_jobs

    def self.create_from_scraped_attributes(attributes)
        # find or create the company
        company = Company.find_or_create_by(name: attributes[:company])

        # remove company from the attributes hash then create an associated job using the remaining attributes hash
        attributes.delete(:company)
        company.jobs.find_or_create_by(attributes) # might need to be where().first_or_create_by?    
    end
end
