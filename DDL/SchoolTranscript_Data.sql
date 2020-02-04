/* ***********
* File: SchoolTranscript_Data.sql
* Author: Sharry Bhatti
*********** */
USE SchoolTranscript
Go

INSERT INTO Students(GivenName, Surname, DateofBirth) --notice no Enrolled column
VALUES  ('Sharry', 'Bhatti', '19720514 10:34:09')

SELECT * FROM Students