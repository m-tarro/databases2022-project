-- view to display overdue books
DROP VIEW IF EXISTS overdue_books;
CREATE VIEW overdue_books AS
SELECT *
FROM borrow
WHERE date_returned IS NULL AND date_due < DATE('2023-01-31'); -- CURDATE() ;