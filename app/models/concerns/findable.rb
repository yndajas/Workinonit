module Findable
    module ClassMethods
        def self.extended(base)
            base.scope :id, ->(id) {where(id: id)}
        end
            
        def self.find_by_id(id)
            self.id(id)[0]
        end
    end
end