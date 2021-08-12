require './controllers/commentcontroller.rb'
require './models/comment'

describe CommentController do
    describe '.add_comment' do
        context "when add comment" do   
            it 'should save file' do
                params = {
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'content #content',
                    'post_id' => 1,
                    'file' => {'filename' => 'fat5uc.jpg','tempfile' => File.new('./spec/fileupload/asd.jpg')}
                }
                
                allow(SecureRandom).to receive(:urlsafe_base64).and_return("abc")
                comment = double
                expect(Comment).to receive(:new).with(params).and_return(comment)
                expect(comment).to receive(:save)
                CommentController.add_comment(params)
                expect(File.new('./public/uploads/abcfat5uc.jpg')).not_to be_nil
                
            end
        end
    end
end
