# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

```


Table: posts

Columns:
title | content | view_count | post_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts, posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (email_address, username) VALUES 
('David@gmail.com', 'David'),
('John@gmail.com', 'John');


INSERT INTO posts (title, content, view_count, post_id) VALUES 
('title1', 'content1', 20, 1),
('title2', 'content2', 12, 1),
('title3', 'content3', 68, 1),
('title4', 'content4', 1000, 2),
('title5', 'content5', 123, 2);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: posts

# Model class
# (in lib/post.rb)

class Post

  attr_accessor :id, :title, :content, :view_count, :post_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: posts

# Repository class
# (in lib/post_repository.rb)
class PostRepository

  def all
    # sql = SELECT * FROM posts;
    # returns an array of post objects for each record in database
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

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
posts = PostRepository.new

posts = posts.all

posts.length # =>  5

posts[0].id # =>  1
posts[0].title # => 'title1'
posts[0].content # => 'content1'
posts[0].account_id # => 1

posts[-1].id # =>  5
posts[-1].title # => 'title5'
posts[-1].content # => 'content5'
posts[-1].account_id # => 2


# 2
# Get a single post

posts = PostRepository.new

post = posts.find(1)

post.id # =>  1
post.title # => 'title1'
post.content # => 'content1'
post.account_id # => 1

# 3 - create and add a new post to the database

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

# 4 - update an existing post in the database
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

# 5 - delete a post in the database

posts = PostRepository.new

posts.delete_by_id(1)

all_posts = posts.all
all_posts.length # => 4
all_posts.first.id # => 2
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._