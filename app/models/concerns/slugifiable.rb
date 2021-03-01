module Slugifiable
    module InstanceMethods
        def slug
            Slugifiable::slugify(self.name || self.title)
        end
    end

    module ClassMethods
        def find_by_slug_and_id(slug, id)
            self.where(user_id: id).find { |instance| instance.slug == slug.downcase }
        end
    end

    def self.slugify(string)
        string.downcase.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/\-+/, '-')
    end
end