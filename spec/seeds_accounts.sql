TRUNCATE TABLE posts, accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO accounts (email_address, username) VALUES 
('David@gmail.com', 'David'),
('John@gmail.com', 'John'),
('Louise@gmail.com', 'Louise'),
('Garry@gmail.com', 'Garry'),
('Larry@gmail.com', 'Larry');