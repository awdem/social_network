require 'account_repository.rb'

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'accounts' })
  connection.exec(seed_sql)
end

RSpec.describe AccountRepository do
  before(:each) do 
    reset_accounts_table
  end

  # (your tests will go here).
end