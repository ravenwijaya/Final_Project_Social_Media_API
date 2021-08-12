require './db/db_connector.rb'
require './models/tag'

class Post
    attr_reader :id, :content,:user_id, :tags, :file_path
    def initialize(params)
        @id = params["id"]
        @content = params["content"]
        @user_id = params["user_id"]
        @file_path = params["file_path"]
        @tags = params["content"] ? params["content"].scan(/#\w+/).flatten.to_set : nil
        
    end
    def save
        return false unless valid?
        client = create_db_client
        client.query("insert into posts(content,user_id,file_path) values ('#{content}',#{user_id},'#{file_path}')")
        rawData = client.query("select last_insert_id() as id")
        post_id = Post.convert_sql_result_to_array(rawData)[0].id

        unless tags.empty?
            tags_id = Array.new
            for tag_name in tags do
                tag_id = Tag.get_tag_id(tag_name)
                unless tag_id.nil?
                    tags_id << tag_id.id
                else
                    tag = Tag.new({'name' => tag_name})
                    tags_id << tag.save
                end
            end
            for id in tags_id do
                client.query("insert into post_tags(post_id,tag_id) values (#{post_id},#{id})")
            end
        end
        post_id
    end
    
   
    def self.get_posts_by_tag_id(id)
        client = create_db_client
        rawData = client.query("select posts.* from post_tags join posts on post_tags.post_id = posts.id where tag_id = #{id}")
        posts = convert_sql_result_to_array(rawData)
        posts.map { |post| post.as_json }

    end
    def self.convert_sql_result_to_array(rawData)
        posts = []
        rawData.each do |data|
          post = Post.new(data)
          posts << post
        end
        posts
    end
    def as_json
        data = {
          id: id,
          content: content,
          user_id: user_id,
          file_path: file_path,
          tags: tags.to_a
        }
        data
    end
    def valid?
        return false if @user_id.nil? || @content.nil?
        true
    end
    
end
