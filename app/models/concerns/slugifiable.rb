module Slugifiable
    module InstanceMethods
        def slug
            Slugifiable::slugify(self.try(:name) || self.try(:title))
        end
    end

    def self.slugify(string)
        string.downcase.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/\-+/, '-')
    end
end