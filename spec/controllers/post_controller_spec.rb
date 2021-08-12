require './controllers/postcontroller.rb'
require './models/post'

describe PostController do
    describe '.add_post' do
        context "when add post" do   
            it 'should save file' do
                params = {
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'content #content',
                    'file' => {'filename' => 'fat5uc.jpg','tempfile' => File.new('./spec/fileupload/asd.jpg')}
                }
                allow(SecureRandom).to receive(:urlsafe_base64).and_return("abc")
                post = double
                expect(Post).to receive(:new).with(params).and_return(post)
                expect(post).to receive(:save)
                PostController.add_post(params)
                expect(File.new('./public/uploads/abcfat5uc.jpg')).not_to be_nil
            end
        end
    end
end
