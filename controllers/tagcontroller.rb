require './models/tag'

class TagController
    def self.get_top_5_tag
        Tag.get_top_5
    end
end
