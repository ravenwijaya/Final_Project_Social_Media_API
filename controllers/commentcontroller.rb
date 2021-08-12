require './models/comment'
require './models/tag'
require 'securerandom'
class CommentController
    def self.add_comment(params)
        unless params["file"].nil?
            filename = params["file"]["filename"]
            file = params["file"]["tempfile"]
            path = "./public/uploads/#{SecureRandom.urlsafe_base64+filename}"
            File.open(path, 'wb') do |f|
                f.write(file.read)
            end
            params["file"]= path
        end
        comment = Comment.new(params)
        comment.save
    end
end