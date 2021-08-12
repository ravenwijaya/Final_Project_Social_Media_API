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
        context 'when initialized without bio' do
            it 'should return true' do
                params={
                    'username' => 'raven',
                    'email' => 'raven@gmail.com'
                }
                user = User.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("select id from users where email = '#{user.email}' or username = '#{user.username}'").and_return([])
                expect(user.valid?).to eq(true)
            end
        end
        context 'when initialized without username' do
            it 'should return false' do
                params={
                    'email' => 'raven@gmail.com',
                    'bio' => 'bio'
                }
                user = User.new(params)
                expect(user.valid?).to eq(false)
            end
        end
        context 'when initialized without email' do
            it 'should return false' do
                params={
                    'username' => 'raven',
                    'bio' => 'bio'
                }
                user = User.new(params)
                expect(user.valid?).to eq(false)
            end
        end
    end
    describe '#save' do
        context "with valid object" do
            it 'should return id' do
                params={
                    'username' => 'raven',
                    'email' => 'raven@gmail.com',
                    'bio' => 'bio'
                }
                user = User.new(params)
                mock_client = double
                allow(user).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("insert into users(username,email,bio) values ('#{user.username}','#{user.email}','#{user.bio}')")
                allow(mock_client).to receive(:query).with("select last_insert_id() as id").and_return([{'id' => 1}])
                expect(user.save).to equal(1)
            end
        end
        context "with invalid object" do
            it 'should return false' do
                params={
                    'username' => 'raven',
                    'bio' => 'bio'
                }
                user = User.new(params)
                allow(user).to receive(:valid?).and_return(false)
                expect(user.save).to equal(false)
            end
        end
    end
end