USE db_project;

-- create administrator with all privileges
CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'adminpassword';
GRANT ALL PRIVILEGES ON db_project.* TO 'administrator'@'localhost';
FLUSH PRIVILEGES;

-- create librarian with privilege to see every table, but edit only borrow
CREATE USER 'librarian'@'localhost' IDENTIFIED BY 'librarianpassword';
GRANT SELECT ON *.* TO 'librarian'@'localhost';
GRANT UPDATE, INSERT, DELETE ON db_project.borrow TO 'librarian'@'localhost';
FLUSH PRIVILEGES;

-- create student with privilege to see select tables
CREATE USER 'student'@'localhost' IDENTIFIED BY 'studentpassword';
GRANT SELECT ON db_project.book TO 'student'@'localhost';
GRANT SELECT ON db_project.book_copy TO 'student'@'localhost';
GRANT SELECT ON db_project.book_author TO 'student'@'localhost';
GRANT SELECT ON db_project.author TO 'student'@'localhost';
GRANT SELECT ON db_project.book_subject TO 'student'@'localhost';
GRANT SELECT ON db_project.subject TO 'student'@'localhost';
GRANT SELECT ON db_project.book_publisher TO 'student'@'localhost';
GRANT SELECT ON db_project.publisher TO 'student'@'localhost';
GRANT SELECT ON db_project.card TO 'student'@'localhost';
GRANT SELECT ON db_project.borrow TO 'student'@'localhost';
FLUSH PRIVILEGES;