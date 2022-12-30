CREATE TRIGGER prevent_insert_on_card
BEFORE INSERT ON card
FOR EACH ROW
BEGIN
	DECLARE registered_library INT;
	SELECT registered_library INTO registered_library
	FROM Student
	WHERE Student.student_id = NEW.student_id;
    
	IF registered_library = FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Not registered in library';
	END IF;
END;