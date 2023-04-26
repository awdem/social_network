require_relative 'account'

class AccountRepository

  def all
    accounts = []
    sql = 'SELECT * FROM accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.each do |record|
      account = Account.new
      set_attributes(account, record)
      accounts << account
    end

    accounts
    # returns an array of account objects for each record in database
  end

  def find_by_id(id)
    account = Account.new
    sql = 'SELECT id, email_address, username FROM accounts where id = $1;'
    search_result = DatabaseConnection.exec_params(sql, [id]).first

    set_attributes(account, search_result)

    account
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


  private 

  def set_attributes(account, record)
    account.id = record["id"].to_i
    account.email_address = record["email_address"]
    account.username = record["username"]
  end
end