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
    sql = 'SELECT id, title, content, view_count, account_id FROM posts where id = $1;'
    search_result = DatabaseConnection.exec_params(sql, [id]).first
    fail 'Post does not exist.' if search_result.nil?
    post = Post.new
    set_attributes(post, search_result)
    post
  end

  def create(post)
    sql = 'INSERT INTO posts (title, content, view_count, account_id) VALUES ($1, $2, $3, $4);'
    params = [post.title, post.content, post.view_count, post.account_id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def update(post)
    sql = 'UPDATE posts SET title = $1, content = $2, view_count = $3, account_id = $4 WHERE id = $5;' 
    params = [post.title, post.content, post.view_count, post.account_id, post.id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def delete_by_id(id)
    existence_check = find_by_id(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    DatabaseConnection.exec_params(sql, [id])
    return nil
  end


  private

  def set_attributes(post, record)
    post.id = record["id"].to_i
    post.title = record["title"]
    post.content = record["content"]
    post.view_count = record['view_count'].to_i
    post.account_id = record["account_id"].to_i
  end

end
