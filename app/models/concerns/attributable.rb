module Attributable
    module InstanceMethods
        def has_value_for?(attribute)
            !!self.send(attribute).try(:length).try(:>, 0)
        end
    end
end