class Status < ApplicationRecord
    extend Findable::ClassMethods
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    has_many :applications
end