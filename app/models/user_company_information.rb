class UserCompanyInformation < ApplicationRecord
    include Attributable::InstanceMethods
    include FormatAndSanitizable::InstanceMethods

    belongs_to :user
    belongs_to :company
end
