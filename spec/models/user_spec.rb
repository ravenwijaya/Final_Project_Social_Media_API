require './models/user.rb'
describe User do
    describe '#initialize, #valid?, and #exist?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params={
                    'username' => 'raven',
                    'email' => 'raven@gmail.com',
                    'bio' => 'bio'
                }

                user = User.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("select id from users where email = '#{user.email}' or username = '#{user.username}'").and_return([])
                expect(user.valid?).to eq(true)
            end
        end
        context 'when initialized with registered email or username' do
            it 'should return false' do
                params={
                    'username' => 'raven',
                    'email' => 'raven@gmail.com',
                    'bio' => 'bio'
                }
                user = User.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("select id from users where email = '#{user.email}' or username = '#{user.username}'").and_return([{'id' => 1}])
                expect(user.valid?).to eq(false)
            end
        end
    end
    
end