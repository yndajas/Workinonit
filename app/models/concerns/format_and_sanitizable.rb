module FormatAndSanitizable
    module InstanceMethods
        def format_and_sanitize(attribute)
            ActionController::Base.helpers.sanitize(self.send(attribute).gsub(/\r?\n|\r/, ActionController::Base.helpers.tag.br))
        end

        def sanitize(attribute)
            ActionController::Base.helpers.sanitize(self.send(attribute))
        end
    end
end
