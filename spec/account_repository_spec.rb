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

  it "find and returns a single account by searching its id" do
    accounts = AccountRepository.new

    account = accounts.find_by_id(1)
    
    expect(account.id).to eq 1
    expect(account.email_address).to eq 'David@gmail.com'
    expect(account.username).to eq 'David'    
  end

  it "creates a new record in the database" do
    accounts = AccountRepository.new

    new_account = Account.new 
    
    new_account.email_address = 'Will@gmail.com'
    new_account.username = 'Will'
    
    accounts.create(new_account)
    
    latest_account = accounts.all.last
    
    expect(latest_account.id).to eq 6
    expect(latest_account.email_address).to eq 'Will@gmail.com'
    expect(latest_account.username).to eq 'Will'    
  end


  it 'updates an existing record' do
    accounts = AccountRepository.new

    old_account = accounts.find_by_id(1)
    
    old_account.email_address = "newemail@gmail.com"
    old_account.username = "new name"
    
    accounts.update(old_account)
    
    updated_record = accounts.find_by_id(1)
    
    expect(updated_record.email_address).to eq "newemail@gmail.com"
    expect(updated_record.username).to eq "new name"  
  end

  it 'deletes an existing record' do
    accounts = AccountRepository.new

    accounts.delete_by_id(1)
    
    all_accounts = accounts.all
    expect(all_accounts.first.id).to eq 2    
    expect(all_accounts.length).to eq 4
  end
end