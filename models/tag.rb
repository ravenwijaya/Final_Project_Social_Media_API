require './db/db_connector'

class Tag
  attr_reader :id, :name
  
  def initialize(params)
    @id = params["id"]
    @name = params["name"]? params["name"].downcase : nil
  end

  def save
    return false unless valid?
    client = create_db_client 
    client.query("insert into tags(name) values ('#{name}')")
    rawData = client.query("select id from tags where name ='#{name}'")
    Tag.convert_sql_result_to_array(rawData)[0].id
    
  end
  def self.get_top_5
    client = create_db_client
    time = Time.now - 60 * 60 * 24
    rawData = client.query("select tag_id, sum(number) total from ( select tag_id, count(tag_id) as number from post_tags where created_at > '#{time}' group by tag_id union all select tag_id, count(tag_id) as number from comment_tags where created_at > '#{time}' group by tag_id) t group by tag_id order by total desc limit 5")
    tagarr = Array.new
    for data in rawData do
      tag = Tag.get_tag_by_id(data["tag_id"])
      tagarr << tag
    end
    tagarr.map { |tag| tag.as_json }
  end

  def self.get_tag_id(name)
    client = create_db_client
    rawData = client.query("select id from tags where name = '#{name}'")
    return convert_sql_result_to_array(rawData)[0] if rawData.any?
    nil
  end

  def self.get_tag_by_id(id)
    client = create_db_client
    rawData = client.query("select * from tags where id = #{id}")

    convert_sql_result_to_array(rawData)[0]
  end

  def self.convert_sql_result_to_array(rawData)
    tags = []
    rawData.each do |data|
      tag = Tag.new(data)
      tags << tag
    end
    tags
  end

  def as_json
    data = {
      id: id,
      name: name
    }
    data
  end

  def exist?
    client = create_db_client
    exist = client.query("select id from tags where name = '#{name}'")
    return true if exist.any?
    false
  end

  def valid?
    return false if @name.nil? || exist?
    true
  end
end

