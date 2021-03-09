module Attributable
    module InstanceMethods
        def has_value_for?(attribute)
            attribute = self.send(attribute)
            
            # if it's a Date or not nil and not empty return true
            !!(attribute.try(:class).try(:==, Date) || attribute.try(:length).try(:>, 0))
        end
    end
end