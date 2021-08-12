# Installation
1. Download and Install [Postman](https://www.postman.com/downloads/)
2. Import FINAL_API_DATABASE.sql to your database
3. Customize .env
## Postman test 
1. Import postman_collection.json
2. Set Environment variabel user_id, user_id2, post_id, and post_id2 with no value
3. Set Environment variabel ip with localhost(test local) or 34.146.206.82(test on GCP)
4. Run the collections
## Rspec Test
1. run gem install rspec 
2. open project directory
3. run rspec -fd spec

