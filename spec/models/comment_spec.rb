# require './test_helper'
require './models/comment.rb'
require './models/tag.rb'
describe Comment do
    describe '#initialize and #valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'user_id' => 1,
                    'post_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                comment = Comment.new(params)
                expect(comment.valid?).to eq(true)
            end
        end
        context 'when initialized without user_id' do
            it 'should return false' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'post_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                comment = Comment.new(params)
                expect(comment.valid?).to eq(false)
            end
        end
        context 'when initialized without content' do
            it 'should return false' do
                params={
                    'id' => 1,
                    'user_id' => 1,
                    'post_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                comment = Comment.new(params)
                expect(comment.valid?).to eq(false)
            end
        end
        context 'when initialized without post_id' do
            it 'should return false' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'user_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                comment = Comment.new(params)
                expect(comment.valid?).to eq(false)
            end
        end
    end
    describe '#save' do
        context "when save comment" do
            it 'should return comment_id' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular #Instagram #hashtags by category?',
                    'user_id' => 1,
                    'post_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                comment = Comment.new(params)
                tag = Tag.new({'id' => 1})
                tag_new = Tag.new({'name' => '#hashtags'})
                comment_id =[Comment.new({'id' => 1})]
                mock_client = double
                rawData = double
                allow(comment).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("insert into comments(content,user_id,post_id,file_path) values ('#{comment.content}',#{comment.user_id},#{comment.post_id},'#{comment.file_path}')")
                expect(mock_client).to receive(:query).with("select last_insert_id() as id").and_return(rawData)
                allow(Comment).to receive(:convert_sql_result_to_array).with(rawData).and_return(comment_id)
                expect(comment.tags).to receive(:empty?).and_return(false)
                allow(Tag).to receive(:get_tag_id).with('#Instagram').and_return(tag)
                allow(Tag).to receive(:get_tag_id).with('#hashtags').and_return(nil)
                allow(Tag).to receive(:new).with({'name' => '#hashtags'}).and_return(tag_new)
                allow(tag_new).to receive(:save).and_return(2)
                expect(mock_client).to receive(:query).with("insert into comment_tags(comment_id,tag_id) values (#{comment_id[0].id},#{1})")
                expect(mock_client).to receive(:query).with("insert into comment_tags(comment_id,tag_id) values (#{comment_id[0].id},#{2})")
                expect(comment.save).to eq(comment_id[0].id)  
            end
        end
    end
    describe '.convert_sql_result_to_array' do
        context "when convert" do
            it 'should return array contains tag object' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'user_id' => 1,
                    'post_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                rawData = [params]
                comment = Comment.new(params)
                expected_result = [comment]
                rawData.each do |data|
                    allow(Comment).to receive(:new).with(data).and_return(comment)
                end
                expect(Comment.convert_sql_result_to_array(rawData)).to eq(expected_result)
            end
        end
    end
end