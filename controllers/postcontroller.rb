require './models/post'
require './models/tag'
require 'securerandom'
class PostController
    def self.add_post(params)
        unless params["file"].nil?
            filename = params["file"]["filename"]
            file = params["file"]["tempfile"]
            path = "./public/uploads/#{SecureRandom.urlsafe_base64+filename}"
            File.open(path, 'wb') do |f|
                f.write(file.read)
            end
            params["file_path"]= path

        end
        post = Post.new(params)
        post.save
        
    end

    def self.get_by_tag_name(params)
        tag_name = params["tag_name"].downcase
        tag_id = Tag.get_tag_id(tag_name)
        return Post.get_posts_by_tag_id(tag_id.id) unless tag_id.nil?
    end
end