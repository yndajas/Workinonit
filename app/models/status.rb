class Status < ApplicationRecord
    include Slugifiable::InstanceMethods
    extend Slugifiable::ClassMethods

    has_many :applications
end