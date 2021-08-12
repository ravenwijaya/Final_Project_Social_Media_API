require './db/db_connector.rb'
require './models/tag'


class Comment
    attr_reader :id, :content,:user_id, :post_id, :file_path, :tags
    def initialize(params)
        @id = params["id"]
        @content = params["content"]
        @user_id = params["user_id"]
        @post_id = params["post_id"]
        @file_path = params["file"]
        @tags = params["content"] ? params["content"].scan(/#\w+/).flatten.to_set : nil
    end
    def save
        return false unless valid?
        client = create_db_client
        client.query("insert into comments(content,user_id,post_id,file_path) values ('#{content}',#{user_id},#{post_id},'#{file_path}')")
        rawData = client.query("select last_insert_id() as id")
        comment_id = Comment.convert_sql_result_to_array(rawData)[0].id

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
                client.query("insert into comment_tags(comment_id,tag_id) values (#{comment_id},#{id})")
            end
        end
        comment_id
    end
    def self.convert_sql_result_to_array(rawData)
        comments = []
        rawData.each do |data|
          comment = Comment.new(data)
          comments << comment
        end
        comments
    end
    def valid?
        return false if @post_id.nil? || @user_id.nil? || @content.nil?
        true
    end
end
