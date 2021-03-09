class UserCompanyInformation < ApplicationRecord
    include FormatAndSanitizable::InstanceMethods

    belongs_to :user
    belongs_to :company
end
