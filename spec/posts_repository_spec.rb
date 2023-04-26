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

  it 'creates and adds a post to the database' do
    posts = PostRepository.new

    new_post = Post.new 
    
    new_post.title = 'new_title'
    new_post.content = 'new_content'
    new_post.view_count = 100
    new_post.account_id = 2
    
    posts.create(new_post)
    
    latest_post = posts.all.last
    
    expect(latest_post.title).to eq 'new_title'
    expect(latest_post.content).to eq 'new_content'
    expect(latest_post.account_id).to eq 2 
    expect(latest_post.view_count).to eq 100   
  end
# fails to create post given an account_id that doesn't exist?

  it 'updates an existing post in the database' do
    posts = PostRepository.new

    old_post = posts.find_by_id(1)
    
    old_post.title = 'new_title'
    old_post.content = 'new_content'
    old_post.view_count = 0
    old_post.account_id = 2
    
    posts.update(old_post)
    
    updated_record = posts.find_by_id(1)
    
    expect(updated_record.title).to eq 'new_title'
    expect(updated_record.content).to eq 'new_content'
    expect(updated_record.view_count).to eq 0
    expect(updated_record.account_id).to eq 2    
  end

# fails to update an existing post given an account_id that doesn't exist?

  it 'deletes a post in the database' do
    posts = PostRepository.new

    posts.delete_by_id(1)
    
    all_posts = posts.all
    expect(all_posts.length).to eq 4
    expect(all_posts.first.id).to eq 2    
  end

  xit 'fails to delete a non-existent record' do
    posts = PostRepository.new
    expect{ posts.delete_by_id(6) }.to raise_error "Post does not exist."
  end

end