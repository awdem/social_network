require_relative 'lib/database_connection'
require_relative 'lib/post_repository'
# # We need to give the database name to the method `connect`.
DatabaseConnection.connect('social_network_test')

database = PostRepository.new
new_post = Post.new

new_post.title = "title"
new_post.content = "content"
new_post.view_count = 50
new_post.account_id = 3


database.create(new_post)


