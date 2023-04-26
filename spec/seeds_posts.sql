TRUNCATE TABLE posts, accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO accounts (email_address, username) VALUES 
('David@gmail.com', 'David'),
('John@gmail.com', 'John');


INSERT INTO posts (title, content, view_count, account_id) VALUES 
('title1', 'content1', 20, 1),
('title2', 'content2', 12, 1),
('title3', 'content3', 68, 1),
('title4', 'content4', 1000, 2),
('title5', 'content5', 123, 2);