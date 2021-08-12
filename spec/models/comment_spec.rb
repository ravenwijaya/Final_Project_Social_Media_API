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
end