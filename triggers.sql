use db_project;

DROP TRIGGER IF EXISTS prevent_insert_on_card;
DROP TRIGGER IF EXISTS prevent_overborrowing;
DROP TRIGGER IF EXISTS book_issuing;
DROP TRIGGER IF EXISTS book_returning;

-- trigger to prevent students who are not registered in the library from opening a card
DELIMITER //
CREATE TRIGGER prevent_insert_on_card
BEFORE INSERT ON card
FOR EACH ROW
BEGIN
	DECLARE registered_library varchar(2);
	SELECT registered_library INTO registered_library
	FROM Student
	WHERE Student.student_id = NEW.student_id;
    
	IF registered_library = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Not registered in library';
	END IF;
END;
// DELIMITER ;

-- trigger to prevent overborrowing of books (limit 5 for university students, 1 for others)
DELIMITER //
CREATE TRIGGER prevent_overborrowing
BEFORE INSERT ON borrow
FOR EACH ROW
BEGIN
  DECLARE borrowed_count INT;
  DECLARE student_uni_registration BOOLEAN;
  
  SELECT COUNT(*) INTO borrowed_count
  FROM borrow
  JOIN card ON borrow.card_id = card.card_id
  JOIN student ON card.student_id = student.student_id
  WHERE borrow.card_id = NEW.card_id AND borrow.date_returned IS NULL;
  
  SELECT student.registered_uni INTO student_uni_registration
  FROM borrow
  JOIN card ON borrow.card_id = card.card_id
  JOIN student ON card.student_id = student.student_id
  WHERE borrow.card_id = NEW.card_id;
  
  IF student_uni_registration = TRUE THEN
	IF borrowed_count >= 5 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Student has already borrowed the maximum number of books';
    END IF;
  ELSE
    IF borrowed_count >= 1 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Student has already borrowed the maximum number of books';
    END IF;
  END IF;
END;
// DELIMITER ;

-- trigger to simplify issuing a book (only need to enter book_copy_id and card_id to issue a book
DELIMITER //
CREATE TRIGGER book_issuing 
BEFORE INSERT ON borrow
FOR EACH ROW 
BEGIN
    SET NEW.borrow_status = TRUE;
	SET NEW.date_borrowed = CURRENT_DATE;
	SET NEW.date_due = DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY);
    SET NEW.date_returned = NULL;
    UPDATE book_copy SET borrowed_status = TRUE WHERE copy_id = NEW.copy_id;
END;
// DELIMITER ;

-- trigger to simplify returning a book (only need to enter book_copy_id to return a book)
DELIMITER //
CREATE TRIGGER book_returning 
BEFORE UPDATE ON borrow
FOR EACH ROW 
BEGIN
    SET NEW.date_returned = CURRENT_DATE;
    UPDATE book_copy SET borrowed_status = FALSE WHERE copy_id = NEW.copy_id;
END;
// DELIMITER ;

-- trigger to simplify inserting a book copy (default borrowed status is false since book is not borrowed)
DELIMITER //
CREATE TRIGGER bookcopy_inserting 
BEFORE INSERT ON book_copy
FOR EACH ROW 
BEGIN
    SET NEW.borrowed_status = FALSE;
END;
// DELIMITER ;