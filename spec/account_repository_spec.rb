require 'account_repository.rb'

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

RSpec.describe AccountRepository do
  before(:each) do 
    reset_accounts_table
  end

  it "returns all records as an array" do
    accounts = AccountRepository.new

    accounts = accounts.all
    
    accounts.length # =>  5
    
    expect(accounts[0].id).to eq 1
    expect(accounts[0].email_address).to eq 'David@gmail.com'
    expect(accounts[0].username).to eq 'David'
    
    expect(accounts[-1].id).to eq 5
    expect(accounts[-1].email_address).to eq 'Larry@gmail.com'
    expect(accounts[-1].username).to eq 'Larry'    
  end
end