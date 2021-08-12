require './models/tag.rb'
describe Tag do
    describe '#initialize, #valid?, and #exist?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params={
                    'name' => '#hashtag'
                }
                tag = Tag.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                
                allow(mock_client).to receive(:query).with("select id from tags where name = '#{tag.name}'").and_return([])
                expect(tag.valid?).to eq(true)
            end
        end
        context 'when initialized with registered tag' do
            it 'should return false' do
                params={
                    'name' => '#hashtag'
                }
                tag = Tag.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("select id from tags where name = '#{tag.name}'").and_return([{"id"=>1}])
                expect(tag.valid?).to eq(false)
            end
        end
    end
    describe '#save' do
        context "when save tag" do
            it 'should return id' do
                params={
                    'name' => '#hashtag'
                }
                convert_result=[Tag.new({'id' => 1,'name'=>'#hashtag'})]
                tag = Tag.new(params)
                mock_client = double
                allow(tag).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("insert into tags(name) values ('#{tag.name}')")
                expect(mock_client).to receive(:query).with("select id from tags where name ='#{tag.name}'")
                allow(Tag).to receive(:convert_sql_result_to_array).and_return(convert_result)
                expect(tag.save).to eq(1)  
            end
        end
    end
    describe '.get_top_5' do
        context "when get top 5 hashtag" do
            it 'should return true' do
                time=Time.now- 60 * 60 * 24
                rawData_result =[
                    {'tag_id' => 1},
                    {'tag_id' => 2},
                    {'tag_id' => 3},
                    {'tag_id' => 4},
                    {'tag_id' => 5}
                ]
                rawData2_result =[
                    {'id' => 1, 'name' => '#hashtag1'},
                    {'id' => 2, 'name' => '#hashtag2'},
                    {'id' => 3, 'name' => '#hashtag3'},
                    {'id' => 4, 'name' => '#hashtag4'},
                    {'id' => 5, 'name' => '#hashtag5'}
                ]
                tagarr=Array.new
                for data in rawData2_result
                    tag=Tag.new(data)
                    tagarr<<tag
                end
                result=[
                    {
                        :id => 1,
                        :name =>"#hashtag1"
                    },
                    {
                        :id => 2,
                        :name =>"#hashtag2"
                    },
                    {
                        :id => 3,
                        :name =>"#hashtag3"
                    },
                    {
                        :id => 4,
                        :name =>"#hashtag4"
                    },
                    {
                        :id => 5,
                        :name =>"#hashtag5"
                    }
                ]
                mock_client = double
                query = "select tag_id, sum(number) total from ( select tag_id, count(tag_id) as number from post_tags where created_at > '#{time}' group by tag_id union all select tag_id, count(tag_id) as number from comment_tags where created_at > '#{time}' group by tag_id) t group by tag_id order by total desc limit 5"
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with(query)
                allow(mock_client).to receive(:query).with(query).and_return(rawData_result)
                rawData_result.each_with_index do |data, index|
                    allow(Tag).to receive(:get_tag_by_id).with(data['tag_id']).and_return(tagarr[index])
                end
                tagarr.map { |tag| allow(tag).to receive(:as_json).and_return({id: tag.id, name: tag.name})}
                expect(Tag.get_top_5).to eq(result)
            end
        end
    end
    describe '.get_tag_id' do
        context "when get tag id" do
            it 'should return tag object' do
                name = '#hashtag'
                tag = Tag.new({'id' => 1})
                query_result = [{'id' => 1}]
                convert_result = [tag]
                mock_client = double 
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("select id from tags where name = '#{name}'").and_return(query_result)
                allow(query_result).to receive(:any?).and_return true
                allow(Tag).to receive(:convert_sql_result_to_array).and_return(convert_result)
                expect(Tag.get_tag_id('#hashtag')).to eq(tag)
            end
        end
    end
    describe '.get_tag_by_id' do
        context "when get tag by id" do
            it 'should return tag object' do
                id = 1
                tag = Tag.new({'id' => 1, 'name' => '#hashtag'})
                convert_result = [tag]
                mock_client = double 
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("select * from tags where id = #{id}")
                allow(Tag).to receive(:convert_sql_result_to_array).and_return(convert_result)
                expect(Tag.get_tag_by_id(1)).to eq(tag)
            end
        end
    end
end