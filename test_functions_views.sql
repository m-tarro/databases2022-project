-- data insertion into borrow (these books are borrowed)
INSERT INTO borrow (card_id, copy_id) VALUES (3,3);
INSERT INTO borrow (card_id, copy_id) VALUES (8,5);
INSERT INTO borrow (card_id, copy_id) VALUES (12,8);
INSERT INTO borrow (card_id, copy_id) VALUES (14,11);
INSERT INTO borrow (card_id, copy_id) VALUES (16,12);
INSERT INTO borrow (card_id, copy_id) VALUES (19,4);

-- data update on borrow (these books are returned)
UPDATE borrow  SET borrow_status = FALSE WHERE copy_id = 3;
UPDATE borrow  SET borrow_status = FALSE WHERE copy_id = 19;

-- testing the function students_borrowed_this_book
SELECT students_borrowed_this_book(4);

-- testing the function
SELECT these_books_borrowed_by_student(1);

-- testing the view overdue_books
SELECT book_copy.ISBN, book.title, overdue_books.copy_id, date_borrowed, date_due
FROM overdue_books
INNER JOIN book_copy ON book_copy.copy_id = overdue_books.copy_id
INNER JOIN book ON book.isbn = book_copy.isbn
ORDER BY book_copy.ISBN, overdue_books.copy_id;

-- testing the function no_of_remaining_copies
SELECT no_of_remaining_copies(6);