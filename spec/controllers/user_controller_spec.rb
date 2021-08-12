require './controllers/usercontroller.rb'
require './models/user'

describe UserController do
    describe '.add_user' do
        context "when add user" do   
            it 'should have correct parameters' do
                params = {
                    'username' => 'raven',
                    'email' => 'raven@gmail.com',
                    'bio' => 'bio'
                }
                user = User.new(params)
                allow(User).to receive(:new).with(params).and_return(user)
                expect(user.username).to eq(params['username'])
                expect(user.email).to eq(params['email'])
                expect(user.bio).to eq(params['bio'])
                expect(user).to receive(:save)
                UserController.add_user(params)
            end
        end
    end
end
