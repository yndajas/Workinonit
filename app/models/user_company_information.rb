class UserCompanyInformation < ApplicationRecord
    include Attributable::InstanceMethods
    include FormatAndSanitizable::InstanceMethods

    belongs_to :user
    belongs_to :company

    validates :website, presence: true, length: {minimum: 1}, unless: :notes?
    validates :notes, presence: true, length: {minimum: 1}, unless: :website?
end
