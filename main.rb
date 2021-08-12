require 'sinatra'
require './db/db_connector.rb'
require './controllers/usercontroller'
require './controllers/postcontroller'
require './controllers/tagcontroller'
require './controllers/commentcontroller'

before do
  content_type :json
end

post '/user/create' do
  if params["email"].nil?
    halt 400, { 
      status:'fail',
      message:'failed to add user, please enter email' }.to_json
  end
  if params["username"].nil?
    halt 400, { 
      status:'fail',
      message:'failed to add user, please enter username' }.to_json
  end
  user_id = UserController.add_user(params)
  if user_id
    halt 200, { 
      status:'success',
      message:'successfully added user',
      user_id:user_id }.to_json
  else
    halt 400, {
      status:'fail',
      message:'failed to add user' }.to_json
  end
end

post '/post/create' do
  if params["content"].nil? 
    halt 400, { 
      status:'fail',
      message:'failed to add post, please enter content' }.to_json
  end
  if params["user_id"].nil?
    halt 400, { 
      status:'fail',
      message:'failed to add post, please enter user_id' }.to_json
  end
  if params["content"].length >1000
    halt 400, { 
      status:'fail',
      message:'Maximum limit of a text is 1000 characters' }.to_json
  end
  post_id = PostController.add_post(params)
  if post_id
    halt 200, { 
      status:'success',
      message:'successfully added post',
      post_id: post_id }.to_json
  else
    halt 400, { 
      status:'fail',
      message:'failed to add post' }.to_json
  end
end

get '/post/:tag_name' do
  PostController.get_by_tag_name(params).to_json
end

get '/tag/trend' do
  TagController.get_top_5_tag.to_json
end

post '/comment/create' do
  if params["content"].nil? 
    halt 400, { 
      status:'fail',
      message:'failed to add comment, please enter content' }.to_json
  end
  if params["content"].length > 1000
    halt 400, { 
      status:'fail',
      message:'failed to add comment, Maximum limit of a text is 1000 characters' }.to_json
  end
  if params["user_id"].nil?
    halt 400, { 
      status:'fail',
      message:'failed to add comment, please enter user_id' }.to_json
  end
  if params["post_id"].nil?
    halt 400, { 
      status:'fail',
      message:'failed to add comment, please enter post_id' }.to_json
  end
  comment_id = CommentController.add_comment(params)
  if comment_id
    halt 200, { 
      status:'success',
      message:'successfully added comment' }.to_json
  else
    halt 400, { 
      status:'fail',
      message:'failed to add comment' }.to_json
  end
end

delete '/delete/dbdata' do
  client = create_db_client
  FileUtils.rm_rf(Dir['./public/uploads/*'])  
  client.query("delete from comment_tags")
  client.query("delete from comments")
  client.query("delete from post_tags")
  client.query("delete from posts")
  client.query("delete from tags")
  client.query("delete from users")
end


