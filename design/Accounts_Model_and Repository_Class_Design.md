# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

```
Table: accounts

Columns:
id | email_address | username
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_accounts.sql)

TRUNCATE TABLE posts, accounts RESTART IDENTITY;


INSERT INTO accounts (email_address, username) VALUES 
('David@gmail.com', 'David'),
('John@gmail.com', 'John'),
('Louise@gmail.com', 'Louise'),
('Garry@gmail.com', 'Garry'),
('Larry@gmail.com', 'Larry');

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby

# Model class
# (in lib/account.rb)
class Account
end

# Repository class
# (in lib/account_repository.rb)
class AccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: accounts

# Model class
# (in lib/account.rb)

class Account

  attr_accessor :id, :email_addres, :username
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you would like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
class AccountRepository

  def all
    # sql = SELECT * FROM accounts;
    # returns an array of account objects for each record in database
  end

  def find_by_id(id)
    # sql = SELECT id, email_address, username FROM accounts where id = $1;
    # returns a single account object with matching id    
  end

  def create(account)
    # sql = INSERT INTO accounts (email_address, username) VALUES ($1, $2);
    # returns nothing 
  end

  def update(account)
    # sql = UPDATE accounts SET email_addres = $1, username = $2 WHERE id = $3; 
    # returns nothing
  end

  def delete_by_id(id)
    # sql = DELETE FROM accounts WHERE id = $1;
    # returns nothing
  end

end



```


## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all accounts

accounts = AccountRepository.new

accounts = accounts.all

accounts.length # =>  5

accounts[0].id # =>  1
accounts[0].email_addres # => 'David@gmail.com'
accounts[0].username # =>  'David'

accounts[-1].id # =>  5
accounts[-1].name # =>  'Larry@gmail.com'
accounts[-1].cohort_name # =>  'Larry'

# 2
# Get a single account

accounts = AccountRepository.new

account = accounts.find(1)

account.id # =>  1
account.email_address # =>  'David@gmail.com'
account.username # =>  'David'

# 3 - create and add a new account to the database

accounts = AccountRepository.new

new_account = Account.new 

new_account.email_address = 'Will@gmail.com'
new_account.username = 'Will'

accounts.create(new_account)

latest_account = accounts.all.last

expect(latest_account.id).to eq 6
expect(latest_account.email_address).to eq 'Will@gmail.com'
expect(latest_account.username).to eq 'Will'

# 4 - update an existing account in the database
accounts = AccountRepository.new

old_account = accounts.find_by_id(1)

old_account.email_address = "newemail@gmail.com"
old_account.username = "new name"

accounts.update(old_account)

updated_record = accounts.find_by_id(1)

expect(updated_record.email_address).to eq "newemail@gmail.com"
expect(updated_record.username).to eq "new name"

# 5 - delete an account in the database

accounts = AccountRepository.new

accounts.delete_by_id(1)

all_accounts = accounts.all
all_accounts.length # => 4
all_accounts.first.id # => 2

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/account_repository_spec.rb

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'accounts' })
  connection.exec(seed_sql)
end

describe accountRepository do
  before(:each) do 
    reset_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._