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