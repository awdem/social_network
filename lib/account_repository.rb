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
  end

  def find_by_id(id)
    account = Account.new
    sql = 'SELECT id, email_address, username FROM accounts where id = $1;'
    search_result = DatabaseConnection.exec_params(sql, [id]).first
    fail 'Account does not exist.' if search_result.to_a.empty?
    set_attributes(account, search_result)
    account
  end

  def create(account)
    sql = 'INSERT INTO accounts (email_address, username) VALUES ($1, $2);'
    params = [account.email_address, account.username]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end
  
  def update(account)
    sql = 'UPDATE accounts SET email_address = $1, username = $2 WHERE id = $3;'
    params = [account.email_address, account.username, account.id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end
  
  def delete_by_id(id)
    existence_check = find_by_id(id)
    sql = 'DELETE FROM accounts WHERE id = $1;'
    DatabaseConnection.exec_params(sql, [id])
    return nil
  end


  private 

  def set_attributes(account, record)
    account.id = record["id"].to_i
    account.email_address = record["email_address"]
    account.username = record["username"]
  end
end