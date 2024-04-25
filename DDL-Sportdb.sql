--------------------------------Project Name SportsDB------------------------------------
--------------------------------DATABASE CREATION----------------------------------------
USE MASTER 
GO 
DROP DATABASE IF EXISTS SportsDB
GO
CREATE DATABASE SportsDB
ON
(
NAME='SportsDB_Data_1',
FILENAME='E:\SportsDB_Data_1.mdf',
SIZE=25mb,
MAXSIZE=100mb,
FILEGROWTH=5%
)
LOG ON
(
NAME='SportsDB_Log_1',
FILENAME='E:\SportsDB_Log_1.ldf',
SIZE=2mb,
MAXSIZE=25mb,
FILEGROWTH=1%
)
USE SportsDB
----Use this Database--
USE SportsDB
---------------------------------TABLE CREATION------------------------------------------

---------------------------------------------------
				--Students--
---------------------------------------------------
DROP TABLE IF EXISTS Students
CREATE TABLE Students
(
StudentRoll INT PRIMARY KEY,
StudentName VARCHAR(20)
)
GO 
PRINT('Successfully Created')
GO
---------------------------------------------------
				--Subjects--
---------------------------------------------------
DROP TABLE IF EXISTS Subjects
CREATE TABLE Subjects
(
SubjectID INT PRIMARY KEY,
SubjectName VARCHAR(20)
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--Sports--
---------------------------------------------------
DROP TABLE IF EXISTS Sports
CREATE TABLE Sports
(
SportID INT PRIMARY KEY,
SportName VARCHAR(20),
Fees MONEY
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--SportsDetails--
---------------------------------------------------
DROP TABLE IF EXISTS SportsDetails
CREATE TABLE SportsDetails
(
StudentRoll INT REFERENCES Students(StudentRoll),
SubjectID INT REFERENCES Subjects(SubjectID),
SportID INT REFERENCES Sports(SportID),
Fields INT
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--StudentAuditLog--
---------------------------------------------------
DROP TABLE IF EXISTS StudentAuditLog
CREATE TABLE StudentAuditLog
(
StudentRoll INT ,
StudentName VARCHAR(20),
Updatedby NVARCHAR(100),
UpdatedOn DATETIME
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--BackUpLog--
---------------------------------------------------
DROP TABLE IF EXISTS BackUpLog
CREATE TABLE BackUpLog
(
StudentRoll INT PRIMARY KEY,
StudentName VARCHAR(20)
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--SportsLog--
---------------------------------------------------
DROP TABLE IF EXISTS SportsLog
CREATE TABLE SportsLog
(
LogID INT IDENTITY(1,1),
SportID INT,
ACTIONS VARCHAR(20)
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--SportsLogTrigger--
---------------------------------------------------
DROP TABLE IF EXISTS SportLogTrigger
CREATE TABLE SportLogTrigger
(
SportID INT PRIMARY KEY,
SportName VARCHAR(20),
Fees MONEY
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--MergedStudentsInfo--
---------------------------------------------------
DROP TABLE IF EXISTS MergedStudentsInfo
CREATE TABLE MergedStudentsInfo
(
StudentRoll INT PRIMARY KEY,
StudentName VARCHAR(20)
)
GO
PRINT('Successfully Created')
GO
---------------------------------------------------
				--BackUpSubjects--
---------------------------------------------------
DROP TABLE IF EXISTS BackUpSubjects
CREATE TABLE BackUpSubjects
(
SubjectID INT PRIMARY KEY,
SubjectName VARCHAR(20)
)
GO
PRINT('Successfully Created')
GO
-----------------------------------------INDEX----------------------------------------------
----CREATE CLUSTERED INDEX-----
CREATE CLUSTERED INDEX IX_SportsDetails
ON SportsDetails(SubjectID);
----Show index in query-----------
EXECUTE sp_helpindex SportsDetails;
----CREATE NON-CLUSTERED INDEX-----
CREATE NONCLUSTERED INDEX IX_Subjects
ON Subjects(SubjectID);
----Show index in query-----------
EXECUTE sp_helpindex DepartmentInfo;
-----------------------------ALTER TABLE----------------------------------------------------
----------------ADD COLUMN----------------------
ALTER TABLE Sports
ADD RefereeName VARCHAR(50)
----------------DROP COLUMN---------------------
ALTER TABLE Sports
DROP RefereeName
----------------DROP TABLE----------------------
DROP TABLE Sports
DROP TABLE Subjects
DROP TABLE Students
DROP TABLE SportsDetails
DROP TABLE MergedStudentsInfo
-----------------------------CREATE VIEW----------------------------------------------------
GO
CREATE VIEW UniversitySports AS
SELECT Students.StudentName,Subjects.SubjectName,Sports.Fees,Fields 
FROM Students 
INNER JOIN SportsDetails ON Students.StudentRoll=SportsDetails.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GO
CREATE VIEW FootBallParticipants AS
SELECT COUNT(SportsDetails.StudentRoll) AS TotalParticipant ,SportsDetails.SportID,Sports.SportName
FROM SportsDetails
INNER JOIN Sports ON SportsDetails.SportID=Sports.SportID
GROUP BY SportsDetails.SportID,Sports.SportName
HAVING SportName='FootBall'
GO
-----------------------------CREATE VIEW WITH SCHEMABINDING AND ENCRYPTION-------------------------------
GO
CREATE VIEW SportsFee
WITH ENCRYPTION,SCHEMABINDING 
AS
SELECT Students.StudentName,Sports.Fees
FROM dbo.Students
INNER JOIN dbo.SportsDetails ON Students.StudentRoll=SportsDetails.StudentRoll
INNER JOIN dbo.Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN dbo.Sports ON Sports.SportID=SportsDetails.SportID
GO
----------------SHOWING THE VIEWS-----------------------
SELECT * FROM UniversitySports
SELECT * FROM FootBallParticipants
SELECT * FROM SportsFee
----------------DROPPING THE VIEWS----------------------
DROP VIEW UniversitySports
DROP VIEW FootBallParticipants
DROP VIEW SportsFee
-----------------------------CREATE STORE PROCEDURES----------------------------------------------------
------------------------STORE PROCEDUE WITHOUR PARAMETERS----------------------
GO
CREATE PROC Sp_StudentDetails
AS
SELECT * FROM Students
GO
EXEC Sp_StudentDetails
----------------STORE PROCEDUE INSERT----------------------
GO 
CREATE PROC sp_Insert
@StudentRoll INT,
@StudentName VARCHAR(20)
AS
INSERT INTO Students VALUES (@StudentRoll,@StudentName)
GO
EXEC sp_Insert 1111,'JhonDoe'
GO
CREATE PROC sp_InsertSubjects
@SubjectID INT,
@SubjectName VARCHAR(20)
AS
INSERT INTO Subjects VALUES (@SubjectID,@SubjectName)
GO
EXEC sp_InsertSubjects 7,'BioChem'
GO
----------------STORE PROCEDUE UPDATE-----------------------
GO
CREATE PROC sp_Update
@StudentRoll INT,
@StudentName VARCHAR(20)
AS
UPDATE Students
SET StudentName=@StudentName
WHERE StudentRoll=@StudentRoll
GO
EXEC sp_Update 1111,'JhonRoe'

----------------STORE PROCEDUE DELETE-----------------------
GO
CREATE PROC sp_delete
@StudentRoll INT
AS
DELETE Students
WHERE StudentRoll=@StudentRoll
GO
EXEC sp_delete 1111;
---------------PROCEDURE IN PARAMETER-----------------------
GO
CREATE PROCEDURE SP_In
(@StudentRoll INT OUTPUT)
AS
SELECT COUNT(@StudentRoll) 
FROM Students

EXECUTE SP_In 11
----------PROCEDURE WITH RETURN STATEMENT--------------------
GO
CREATE PROCEDURE SP_Return
(@StudentRoll INT)
AS
SELECT StudentRoll,StudentName
FROM Students
WHERE StudentRoll = @StudentRoll
GO
DECLARE @return_value INT
EXECUTE @return_value = SP_Return @StudentRoll = 1101
SELECT  'Return Value' = @return_value;
-----------------------------CREATE TRIGGERS----------------------------------------------------
----------------AFTER TRIGGER-------------------------------
GO
CREATE TRIGGER tr_Insert
ON Students
AFTER UPDATE,INSERT
AS
BEGIN
INSERT INTO StudentAuditLog
SELECT i.StudentRoll,i.StudentName,SUSER_NAME(),GETDATE()
FROM  Students INNER JOIN inserted i ON i.StudentRoll=Students.StudentRoll
END
GO
----------------AFTER TRIGGER TESTING---------------------------------
UPDATE Students
SET StudentName='Rohim Saleh'
WHERE StudentRoll=1111
GO
SELECT * FROM Students
SELECT * FROM BackUpLog
----------------AFTER TRIGGER--------------------------------------
GO
CREATE TRIGGER tr_Update
ON Students 
AFTER INSERT,UPDATE
AS
INSERT INTO BackUpLog(StudentRoll,StudentName)
SELECT i.StudentRoll,i.StudentName
FROM inserted i
GO
----------------AFTER TRIGGER TESTING-------------------------------
INSERT INTO Students VALUES (1113,'Jordan Pele')
SELECT * FROM Students
SELECT * FROM StudentAuditLog
----------------INSERT TRIGGER--------------------------------------
GO
CREATE TRIGGER tr_InsertSub
ON Subjects
AFTER INSERT
AS
BEGIN
INSERT INTO BackUpSubjects(SubjectID,SubjectName)
SELECT i.SubjectID,i.SubjectName
FROM inserted i
END
----------------INSERT TRIGGER TESTING-----------------------------
INSERT INTO Subjects VALUES(7,'EEE')
SELECT * FROM Subjects
SELECT * FROM BackUpSubjects
----------------UPDATE TRIGGER-------------------------------------
GO
CREATE TRIGGER tr_UpdateSport
ON Sports
AFTER UPDATE
AS 
BEGIN
INSERT INTO SportLogTrigger
SELECT i.SportID,i.SportName,i.Fees
FROM inserted i
END
GO
----------------UPDATE TRIGGER TESTING-----------------------------
UPDATE Sports
SET SportName='LUDO'
WHERE SportID=4
SELECT * FROM Sports
SELECT * FROM SportLogTrigger
----------------INSTEAD OF TRIGGER---------------------------------
GO
CREATE TRIGGER tr_InsteadDelete
ON Sports 
INSTEAD OF DELETE
AS
BEGIN
SET NOCOUNT ON
DECLARE @SportID INT
SELECT @SportID=DELETED.SportID
FROM DELETED
IF @SportID=3
    BEGIN
    RAISERROR('Can not delete',16,1)
    ROLLBACK
    INSERT INTO SportsLog VALUES(@SportID,'This value is protected')
    END
ELSE
    BEGIN
	DELETE Sports
    WHERE SportID=@SportID
    INSERT INTO SportLog VALUES(@SportID,'DELETED')
    END
END
GO
SELECT * FROM Sports
SELECT * FROM SportLog
----------------INSTEAD OF TRIGGER TESTING-----------------------------
DELETE Sports
WHERE SportID=3
-----------------------------CREATE FUNCTIONS----------------------------------------------------
------------------TABLE VALUED FUNCTION--------------------------------
GO
CREATE FUNCTION fn_table()
RETURNS TABLE
RETURN
(
SELECT SportID,StudentRoll,Fields
FROM SportsDetails
)
GO
----------------TABLE VALUED FUNCTION TESTING----------------------------
SELECT * FROM dbo.fn_table()
GO
----------------SCALAR VALUED FUNCTION--------------------------------
GO
GO
CREATE FUNCTION fn_PCon()
RETURNS INT
BEGIN 
DECLARE @A INT
SELECT @A=COUNT(*) FROM SportsDetails
RETURN @A
END
GO
----------------SCALAR VALUED FUNCTION TESTING---------------------------
SELECT dbo.fn_PCon()
GO
----------------MULTI-STATE FUNCTION-------------------------------------
GO
CREATE FUNCTION fn_Ptemp()
RETURNS @OutTable 
TABLE(SportName NVARCHAR(50),Fees DECIMAL(18,2),Extended_Fee DECIMAL(18,2))
BEGIN 
INSERT INTO @OutTable(SportName,Fees,Extended_Fee)
SELECT SportName,Fees,Fees+10
FROM Sports
RETURN
END
GO
----------------MULTI-STATE FUNCTION TESTING------------------------------
SELECT * FROM dbo.fn_Ptemp()
GO


-----------------------------------------------------------------------------------END OF DDL-------------------------------------------------------------------------------------------------------
