require_relative 'post'


class PostRepository

  def all
    posts = []
    sql = 'SELECT * FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.each do |record|
      post = Post.new
      set_attributes(post, record)
      posts << post
    end

    posts
  end

  def find_by_id(id)
    # sql = SELECT id, title, content, view_count, post_id FROM posts where id = $1;
    # returns a single post object with matching id    
  end

  def create(post)
    # sql = INSERT INTO posts (email_address, username) VALUES ($1, $2);
    # returns nothing 
  end

  def update(post)
    # sql = UPDATE posts SET title = $1, content = $2, view_count = $3, post_id = $4 WHERE id = $5; 
    # returns nothing
  end

  def delete_by_id(id)
    # sql = DELETE FROM posts WHERE id = $1;
    # returns nothing
  end


  private

  def set_attributes(post, record)
    post.id = record["id"]
    post.title = record["title"]
    post.content = record["contents"]
    post.account_id = record["account_id"]
  end

end