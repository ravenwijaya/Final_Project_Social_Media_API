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
end