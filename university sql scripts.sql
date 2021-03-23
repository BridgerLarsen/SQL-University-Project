-- Insert scripts for the courses table:

INSERT INTO courses(courses_name)
VALUES ('Math');

INSERT INTO courses(courses_name)
VALUES ('English');

INSERT INTO courses(courses_name)
VALUES ('History');

INSERT INTO courses(courses_name)
VALUES ('Science');

INSERT INTO courses(courses_name)
VALUES ('Accouting');

INSERT INTO courses(courses_name)
VALUES ('Business Managment');

INSERT INTO courses(courses_name)
VALUES ('Political Science');

INSERT INTO courses(courses_name)
VALUES ('Media Arts');

INSERT INTO courses(courses_name)
VALUES ('Engineering');

INSERT INTO courses(courses_name)
VALUES ('Software Engineering');

INSERT INTO courses(courses_name)
VALUES ('Finance');

INSERT INTO courses(courses_name)
VALUES ('Health Science');

INSERT INTO courses(courses_name)
VALUES ('Mechanics');

INSERT INTO courses(courses_name)
VALUES ('Pilot');

INSERT INTO courses(courses_name)
VALUES ('IT Managment');


-- Insert script that populates the students table:

BEGIN;
DELIMITER $$
CREATE PROCEDURE students_data()
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i <= 150 DO
		INSERT INTO students(students_name)
        VALUES (CONCAT('Student', i));
        SET i = i + 1;
	END WHILE;
END $$ 
DELIMITER ;
CALL students_data();
DROP PROCEDURE students_data;

ROLLBACK;


-- Insert script that populates the professors table:

BEGIN;
DELIMITER $$
CREATE PROCEDURE professors_data()
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i <= 15 DO
		INSERT INTO professors(professors_name, professors_courses_id)
        VALUES (CONCAT('Professor', i), i);
        SET i = i + 1;
	END WHILE;
END $$ 
DELIMITER ;
CALL professors_data();
DROP PROCEDURE professors_data;

ROLLBACK;


-- Insert script that populated the grades table:

BEGIN;
DELIMITER $$
CREATE PROCEDURE grades()
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i <= 150 DO
		INSERT INTO grades(grades_students_id, grades_courses_id, grades_score)
        VALUES (i, FLOOR(RAND() * (16 - 1) + 1), FLOOR(RAND() * (100 - 1) + 2)); # need notes for this...
        SET i = i + 1;
	END WHILE;
END $$ 
DELIMITER ;
CALL grades();
DROP PROCEDURE grades;

ROLLBACK;





-- Query Scripts:

-- Average grade that is given by each professor: 

SELECT professors_name, CEIL(AVG(grades_score)) AS 'Average Given Grade'
FROM grades g
JOIN students s
ON s.students_id = g.grades_students_id
JOIN courses c
ON c.courses_id = g.grades_courses_id
JOIN professors p
ON p.professors_courses_id = c.courses_id
GROUP BY professors_name;


-- The top grade for each student

SELECT students_name, MAX(grades_score) AS 'Top Grade For Student'
FROM grades g
JOIN students s 
ON s.students_id = g.grades_students_id
GROUP BY students_name;


-- Group Students by the courses that they are enrolled in:

SELECT students_name, courses_name
FROM grades g
JOIN courses c
ON c.courses_id = g.grades_courses_id
JOIN students s 
ON s.students_id = g.grades_students_id
ORDER BY students_id ASC;

-- Create a summary report of courses and their average grades, sorted by the most challenging 
-- course(course with the lowest average grade) to the easiest course.

SELECT courses_name, CEIL(AVG(grades_score)) AS average_course_scores
FROM grades g
JOIN courses c
ON c.courses_id = g.grades_courses_id
GROUP BY courses_name
ORDER BY average_course_scores ASC;


-- Finding which student and professor have the most courses in common

SELECT students_name, professors_name, COUNT(*) AS classes_in_common
FROM grades g
JOIN students s
ON s.students_id = g.grades_students_id
JOIN courses c
ON c.courses_id = g.grades_courses_id
JOIN professors p
ON p.professors_id = c.courses_professors_id
GROUP BY professors_name, students_name
ORDER BY classes_in_common DESC;
















