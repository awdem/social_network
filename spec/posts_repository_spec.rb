require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it 'returns all posts as an array of post objects' do
    posts = PostRepository.new

    posts = posts.all
    
    expect(posts.length) # =>  5
    
    expect(posts[0].id).to eq  1
    expect(posts[0].title).to eq 'title1'
    expect(posts[0].content).to eq 'content1'
    expect(posts[0].view_count).to eq 20
    expect(posts[0].account_id).to eq 1
    
    expect(posts[-1].id).to eq  5
    expect(posts[-1].title).to eq 'title5'
    expect(posts[-1].content).to eq 'content5'
    expect(posts[-1].view_count).to eq 123
    expect(posts[-1].account_id).to eq 2    
  end

  it 'finds a single post by id' do
    posts = PostRepository.new

    post = posts.find_by_id(3)
    
    expect(post.id).to eq 3
    expect(post.title).to eq 'title3'
    expect(post.content).to eq 'content3'
    expect(post.view_count).to eq 68

    expect(post.account_id).to eq 1    
  end

  it 'fails to find a non-existent post' do
    posts = PostRepository.new
    expect{ posts.find_by_id(6) }.to raise_error 'Post does not exist.'
  end

  xit 'creates and adds a post to the database' do
    posts = PostRepository.new

    new_post = post.new 
    
    new_post.title = 'new_title'
    new_post.content = 'new_content'
    new_post.account_id = 2
    
    posts.create(new_post)
    
    latest_post = posts.all.last
    
    latest_post.title # => 'new_title'
    latest_post.content # => 'new_content'
    latest_post.account_id # => 2    
  end
# fails to create post given an account_id that doesn't exist?

  xit 'updates an existing post in the database' do
    posts = PostRepository.new

    old_post = posts.find_by_id(1)
    
    old_post.title = 'new_title'
    old_post.content = 'new_content'
    old_post.account_id = 2
    
    posts.update(old_post)
    
    updated_record = posts.find_by_id(1)
    
    old_post.title # => 'new_title'
    old_post.content # => 'new_content'
    old_post.account_id # => 2    
  end

# fails to update an existing post given an account_id that doesn't exist?

  xit 'deletes a post in the database' do
    posts = PostRepository.new

    posts.delete_by_id(1)
    
    all_posts = posts.all
    all_posts.length # => 4
    all_posts.first.id # => 2    
  end

  xit 'fails to delete a non-existent record' do
    posts = PostRepository.new
    expect{ posts.delete_by_id(6) }.to raise_error "Post does not exist."
  end

end