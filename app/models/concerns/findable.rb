module Findable
    module ClassMethods
        def self.extended(base)
            base.scope :id, ->(id) {where(id: id)}
        end

        def find_by_id(id)
            self.id(id)[0]
        end

        def find_by_user_reverse_by_date(user, date_field)
            self.user(user).order(:"#{date_field}" => :desc)
        end
    
        def find_by_user_and_company_reverse_by_date(user, company, date_field)
            self.find_by_user_reverse_by_date(user, date_field).collect do |object|
                object if object.company == company
            end.compact
        end    
    end
end