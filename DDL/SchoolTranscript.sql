/* ***********
* File: SchoolTranscript.sql
* Author: Sharry Bhatti
*
*  CREATE DATABASE SchoolTranscript
*********** */
USE SchoolTranscript
GO
/* === Drop Statements === */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudentCourses')
    DROP TABLE StudentCourses
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses')
    DROP TABLE Courses 
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
    DROP TABLE Students
/* === Create Tables === */
CREATE TABLE Students
(
	StudentID       int
        CONSTRAINT PK_Students_StudentID
            PRIMARY KEY 
        IDENTITY(20200001, 1)       NOT NULL,
    GivenName       varchar(50)     NOT NULL,
    Surname         varchar(50)    
		CONSTRAINT CH_Students_Surname
			CHECK (Surname LIKE '__%')			--likE ALLOWS US TO DO A "PATTERN-MATCH" OF VALUES
		--- CHECK (Surname LIKE '[a-z][a-z]%')	-- two letters plus any other chars	
		--						 \ 1 / \ 1 /
		-- Positive match for 'Fred'
		-- Positve match for 'Wu'
		-- Negative match for 'F' 
		-- Negative match for '2udor'	
							     	NOT NULL,		
    DateofBirth     datetime      
		CONSTRAINT CH_Students_DateOfBirth
			CHECK (DateOfBirth < GETDATE ())
								    NOT NULL,
    Enrolled        bit
        CONSTRAINT DF_Students_Enrolled
            DEFAULT (1)             NOT NULL
)

CREATE TABLE Courses
(
	Number          varchar(10)
        CONSTRAINT PK_Courses_Number
            PRIMARY KEY             NOT NULL,
    [Name]          varchar(50)     NOT NULL,
    Credits         decimal(3,1)   
			CONSTRAINT CK_Courses_Credits
				CHECK (Credits > 0 AND Credits <= 6)
									NOT NULL,
    [Hours]         tinyint 
		CONSTRAINT CK_Courses_Hours 
			CHECK ([HOURS] BETWEEN 15 AND 180)  
--	same	CHECK ([HOURS] >= AND [Hours] <= 180)
								   NOT NULL,
    Active          bit
        CONSTRAINT DF_Courses_Active
            DEFAULT (1)             NOT NULL,
    Cost            money        
		CONSTRAINT Cost
			CHECK (Cost >= 0)	    NOT NULL,
)

CREATE TABLE StudentCourses
(
	StudentID       int     
        CONSTRAINT FK_StudentCourses_StudentID_Students_StudentID 
            FOREIGN KEY REFERENCES Students(StudentID)
                                    NOT NULL,
    CourseNumber    varchar(10)  
        CONSTRAINT FK_StudentCourses_CourseNumber_Courses_Number 
            FOREIGN KEY REFERENCES Courses(Number)
                                    NOT NULL,
    [Year]          tinyint         NOT NULL,
    Term            char(3)         NOT NULL,
    FinalMark       tinyint             NULL,
    [Status]        char(1)        
		CONSTRAINT CK_StudentCourses_Status
			CHECK ([Status] = 'E' OR 
				   [Status] = 'C' OR 
				   [Status] = 'W' ) 
		--  CHECK ([Status] IN ('E', 'C', 'W'))
									NOT NULL,
    -- Table-level constraint for composite keys
    CONSTRAINT PK_StudentCourses_StudentID_CourseNumber
        PRIMARY KEY (StudentID, CourseNumber),
	-- Table-level constraint involving more than one column
	CONSTRAINT CK_StudentCourses_FinalMark_Status
		CHECK (([Status] = 'C' AND FinalMark IS NOT NULL)
				OR
				([Status] IN ('E', 'W') AND FinalMark is NULL))
)


/* ----- Indexes ------ */
-- For all foreign keys
CREATE NONCLUSTERED INDEX IX_StudentCourses_StudentID
	ON StudentCourses (StudentID)
	CREATE NONCLUSTERED INDEX IX_StudentCourses_CourseNumber
	ON StudentCourses (CourseNumber)

-- For other columns where searching/sorting might be important
CREATE NONCLUSTERED INDEX IX_Students_Surname
	ON Students (Surname)

	/* ----- ALTER TABLE statements -------- */
-- 1) Add a PostalCode for the Students table
ALTER TABLE Students
	ADD PostalCode char(6) NULL 
	-- Adding this as a nullable column, because students already exist,
	-- and we don't have postal codes for those students.
GO  -- I have to break the above code as a seperate batch from the following code

-- 2) Make sure the PostalCode follows the correct pattern A#A#A#
ALTER TABLE Students
	ADD CONSTRAINT CK_Students_PostalCode
		CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')