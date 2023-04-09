-- function to display who borrowed a specific book (by isbn)
DROP FUNCTION IF EXISTS students_borrowed_this_book;
DELIMITER //
CREATE FUNCTION students_borrowed_this_book(isbn VARCHAR(13)) 
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE students VARCHAR(255);
    SELECT GROUP_CONCAT(student.student_id SEPARATOR ',') INTO students
    FROM student
    INNER JOIN card ON card.student_id = student.student_id
    INNER JOIN borrow ON borrow.card_id = card.card_id
    INNER JOIN book_copy ON book_copy.copy_id = borrow.copy_id
    INNER JOIN book ON book.isbn = book_copy.isbn
    WHERE book.isbn = isbn AND borrow.date_returned IS NULL;
    RETURN students;
END
// DELIMITER ;

-- function to display what books a student has borrowed (by student_id)
DROP FUNCTION IF EXISTS these_books_borrowed_by_student;
DELIMITER //
CREATE FUNCTION these_books_borrowed_by_student(student_id INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE isbns VARCHAR(255);
    SELECT GROUP_CONCAT(book.isbn SEPARATOR ',') INTO isbns
    FROM book
    INNER JOIN book_copy ON book_copy.isbn = book.isbn
    INNER JOIN borrow ON borrow.copy_id = book_copy.copy_id
    INNER JOIN card ON card.card_id = borrow.card_id
    INNER JOIN student ON student.student_id = card.student_id
    WHERE student.student_id = student_id AND borrow.date_returned IS NULL;
    RETURN isbns;
END
// DELIMITER ;

-- function to display number of remaining copies of a given book
DROP FUNCTION IF EXISTS no_of_remaining_copies;
DELIMITER //
CREATE FUNCTION no_of_remaining_copies(isbn VARCHAR(13))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE count_copies INT;
    SELECT COUNT(*) INTO count_copies
    FROM book_copy
    WHERE book_copy.isbn = isbn AND book_copy.borrowed_status IS FALSE;
    RETURN count_copies;
END
// DELIMITER ;