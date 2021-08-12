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
    describe '#save' do
        context "when save post" do
            it 'should return post_id' do
                params={
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'What are the most popular #Instagram #hashtags by category?',
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                post = Post.new(params)
                tag = Tag.new({'id' => 1})
                tag_new = Tag.new({'name' => '#hashtags'})
                post_id =[Post.new({'id' => 1})]
                mock_client = double
                mock_rawData = double
                allow(post).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("insert into posts(content,user_id,file_path) values ('#{post.content}',#{post.user_id},'#{post.file_path}')")
                expect(mock_client).to receive(:query).with("select last_insert_id() as id").and_return(mock_rawData)
                allow(Post).to receive(:convert_sql_result_to_array).with(mock_rawData).and_return(post_id)
                expect(post.tags).to receive(:empty?).and_return(false)
                allow(Tag).to receive(:get_tag_id).with('#Instagram').and_return(tag)
                allow(Tag).to receive(:get_tag_id).with('#hashtags').and_return(nil)
                allow(Tag).to receive(:new).with({'name' => '#hashtags'}).and_return(tag_new)
                allow(tag_new).to receive(:save).and_return(2)
                expect(mock_client).to receive(:query).with("insert into post_tags(post_id,tag_id) values (#{post_id[0].id},#{1})")
                expect(mock_client).to receive(:query).with("insert into post_tags(post_id,tag_id) values (#{post_id[0].id},#{2})")
                expect(post.save).to eq(post_id[0].id)  
            end
        end
    end
    describe '.convert_sql_result_to_array' do
        context "when convert" do
            it 'should return array contains tag object' do
                params ={
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'What are the most popular #Instagram #hashtags by category?',
                    'file_path' => '/mnt/c/Users/wijay/code/final/public/uploads/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                rawData = [params]
                post = Post.new(params)
                expected_result = [post]
                rawData.each do |data|
                    allow(Post).to receive(:new).with(data).and_return(post)
                end
                expect(Post.convert_sql_result_to_array(rawData)).to eq(expected_result)
            end
        end
    end
    describe '.get_posts_by_tag_id' do
        context "when get post by tag id" do
            it 'should return tag object' do
                params={
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'What?',
                    'file_path' => '/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }
                id = 1
                post = Post.new(params)
                convert_result = Array.new 
                convert_result << post
                as_json_result=
                    {
                        :id => 1,
                        :user_id => 1,
                        :content => 'What?',
                        :file_path => '/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                    }
                expected_result =[{
                    :id => 1,
                    :user_id => 1,
                    :content => 'What?',
                    :file_path => '/81Y4tT_iJhaYBI-LnwvYowfat5uc.jpg'
                }]
                mock_client = double 
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("select posts.* from post_tags join posts on post_tags.post_id = posts.id where tag_id = #{id}")
                allow(Post).to receive(:convert_sql_result_to_array).and_return(convert_result)
                convert_result.map { |post| allow(post).to receive(:as_json).and_return(as_json_result)}
                expect(Post.get_posts_by_tag_id(1)).to eq(expected_result)
            end
        end
    end
end