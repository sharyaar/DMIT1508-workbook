/* ***********
* File: SchoolTranscript_Data.sql
* Author: Sharry Bhatti
*********** */
USE SchoolTranscript
Go

INSERT INTO Students(GivenName, Surname, DateofBirth) --notice no Enrolled column
VALUES  ('Sharry', 'Bhatti', '19720514'),
		('Charles', 'Kuhn', '19990806 00:00:00 AM'),
		('Wyatt', 'Shaw', '19920702 11:00:24 PM'),
		('Chloe', 'James', '19740501 12:14:25 AM'),
		('Mae', 'Garrett', '19880111 05:15:12 PM')


SELECT * FROM Students

INSERT INTO Courses(Number, [Name], Credits, [Hours], Cost)
VALUES	('DMIT-1508', 'Database Fundamentals', 3.0, 60, 750),
		('CPSC-1012', 'Programming Fundamentals', 3.0, 60, 750),
		('DMIT-1720', 'OOP Fundamentals', 4.5, 90, 850),
		('DMIT-2210', 'Agile Development', 4.5, 90, 850),
		('DMIT-1718', 'Software Testing', 4.5, 90, 850)

SELECT * FROM Courses
/*
-- The following should fail, because of a check constraint INSERT INTO Students(Givenname, Surname, DateofBirth) -- notice no Enrolled column
VALUES ('Dan', 'G', '19720514 10:34P09 PM')
*/

SELECT	Number, [Name], Credits, [Hours]
FROM	Courses
WHERE	[NAME] LIKE '%Fundamentals%'

-- Write a query to get the first/last names of all students
-- Whose last name starts with a "G"
SELECT	GivenName, Surname, DateOfBirth
FROM	Students
WHERE	[Surname] LIKE 'G%'


-- Removing all the data
DELETE FROM Students


