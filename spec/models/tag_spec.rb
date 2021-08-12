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
end