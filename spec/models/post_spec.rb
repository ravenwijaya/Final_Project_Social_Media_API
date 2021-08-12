require './models/post.rb'
require './models/tag.rb'
describe Post do
    describe '#initialize and #valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'user_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                post = Post.new(params)
                expect(post.valid?).to eq(true)
            end
        end
        context 'when initialized without user_id' do
            it 'should return false' do
                params={
                    'id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                post = Post.new(params)
                expect(post.valid?).to eq(false)
            end
        end
        context 'when initialized without content' do
            it 'should return false' do
                params={
                    'id' => 1,
                    'user_id' => 1,
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                post = Post.new(params)
                expect(post.valid?).to eq(false)
            end
        end
    end
    describe '#as_json' do
        context "when as json" do
            it 'should return as json' do
                post = Post.new({
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'What are the most popular Instagram #hashtags by category?',
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
            })
                expected_result = {
                    id: post.id, 
                    content: post.content, 
                    user_id: post.user_id, 
                    file_path: post.file_path, 
                    tags: ['#hashtags']}
                expect(post.as_json).to eq(expected_result)
            end
        end
    end
end