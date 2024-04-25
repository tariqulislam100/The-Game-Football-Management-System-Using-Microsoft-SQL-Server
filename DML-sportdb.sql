--------------------------------DATABASE USE----------------------------------------
USE SportsDB
GO
--------------------------------DATA INSERTION---------------------------------------

---------------------------------------------------
				--Students--
---------------------------------------------------
INSERT INTO Students VALUES(1101,'Cierra Newton'),
                           (1102,'Ramon Morales'),
						   (1103,'Rylie Burns'),
						   (1104,'Jacob Mcgee'),
						   (1105,'Kaylen Zavala'),
						   (1106,'Sarai Bond'),
						   (1107,'Maxim Barnes'),
						   (1108,'Brittany Robbins'),
						   (1109,'Thalia Johnston'),
						   (1110,'Jaquan Rivera')
SELECT * FROM Students
---------------------------------------------------
				--Subjects--
---------------------------------------------------
INSERT INTO Subjects VALUES (1,'Math'),
                            (2,'Chemistry'),
							(3,'BioTech'),
							(4,'Physics'),
							(5,'English'),
							(6,'Bangla')
SELECT * FROM Subjects
---------------------------------------------------
				--Sports--
---------------------------------------------------
INSERT INTO Sports VALUES (1,'FootBall',600),
                          (2,'Cricket',600),
						  (3,'VollyBall',300),
						  (4,'HandBall',200)
SELECT * FROM Sports
---------------------------------------------------
				--SportsDetails--
---------------------------------------------------
INSERT INTO SportsDetails VALUES (1101,1,1,1),
                                 (1102,2,1,1),
								 (1102,2,2,2),
								 (1103,1,1,1),
								 (1103,1,3,3),
								 (1104,2,2,2),
								 (1105,3,3,3),
								 (1106,4,3,3),
								 (1106,4,4,4),
								 (1107,5,2,2),
								 (1108,6,2,2),
								 (1108,6,3,3),
								 (1109,6,4,4),
								 (1110,5,4,4),
								 (1110,5,1,1)
SELECT * FROM SportsDetails
--------------------------------VIEW TABLES----------------------------------------
SELECT * FROM Students
SELECT * FROM Subjects
SELECT * FROM Sports
SELECT * FROM SportsDetails
--------------------------------DML DELETE SINGLE ROW------------------------------
DELETE Students
WHERE StudentRoll=1111
--------------------------------DML DELETE ALL RECORD------------------------------
DELETE Students
--------------------------------COUNT ALL ROW--------------------------------------
SELECT COUNT(*) AS Counting FROM  SportsDetails
--------------------------------COUNT ALL ROW--------------------------------------
SELECT COUNT(StudentRoll) AS NumberOfParticipants FROM SportsDetails
----------------------------AVERAGE Fee of Sports----------------------------------
SELECT AVG(Fees) AS "Average Fees" FROM Sports;

---------------------------Summetion Fee of Sports---------------------------------
SELECT SUM(Fees) AS "Total Fees" FROM Sports;

---------------------------Maximum Fee of Sports-----------------------------------
SELECT MAX(Fees) as "Max Fee" FROM Sports;

---------------------------Minimum Fee of Sports-----------------------------------
SELECT MIN(Fees) as "Min Fee" FROM Sports;
---------------------------------Order By------------------------------------------
SELECT StudentName,Fields 
FROM Students 
INNER JOIN SportsDetails ON Students.StudentRoll=SportsDetails.StudentRoll
ORDER BY Fields DESC

SELECT SubjectName,StudentName
FROM Students INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
ORDER BY SubjectName ASC
--------------------Showing all results using Group By--------------------------------------
SELECT StudentName,Fields,Students.StudentRoll 
FROM Students 
INNER JOIN SportsDetails ON Students.StudentRoll=SportsDetails.StudentRoll
GROUP BY StudentName,Fields,Students.StudentRoll 

SELECT SubjectName,StudentName,Fees
FROM Students INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN  Sports ON Sports.SportID=SportsDetails.SportID
Group BY SubjectName,StudentName,Fees
-------------Finding Out Total Participants Playing Football Using HAVING-------------------
SELECT COUNT(SportsDetails.StudentRoll) AS TotalParticipant ,SportsDetails.SportID,Sports.SportName
FROM SportsDetails
INNER JOIN Sports ON SportsDetails.SportID=Sports.SportID
GROUP BY SportsDetails.SportID,Sports.SportName
HAVING SportName='FootBall'
-------------Finding Out Fees that Were Greater Than 600 Using HAVING------------------------
SELECT DISTINCT(Students.StudentName),SUM(Sports.Fees) AS TotalFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY Students.StudentName
HAVING SUM(Sports.Fees)>600
---------------------------------Using Aggregate Function ROLL UP----------------------------
SELECT (Students.StudentName),SUM(Sports.Fees) AS TotalFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY ROLLUP (Students.StudentName)
---------------------------------Using Aggregate Function CUBE-------------------------------
SELECT (Students.StudentName),AVG(Sports.Fees) AS AverageFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY CUBE (Students.StudentName)
---------------------------------Using GROUPING SETS To Group--------------------------------
SELECT COUNT(SportsDetails.StudentRoll) AS TotalParticipant ,SportsDetails.SportID,Sports.SportName
FROM SportsDetails
INNER JOIN Sports ON SportsDetails.SportID=Sports.SportID
GROUP BY GROUPING SETS(SportsDetails.SportID,Sports.SportName)
-------------------------Finding Sum,Average,Count Over Student Name-------------------------
SELECT DISTINCT(Students.StudentName),
SUM(Sports.Fees)OVER(PARTITION BY Students.StudentName)  AS TotalFee,
AVG(Sports.Fees)OVER(PARTITION BY Students.StudentName)  AS AvgFee,
COUNT(Sports.Fees)OVER(PARTITION BY Students.StudentName)AS TotalSport,
Subjects.SubjectName
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
--------------Finding Out The Records Where A particualr SubjectName EXISTS------------------
SELECT CONCAT(StudentName,'-',SubjectName) AS NameWithSubject
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
WHERE EXISTS (SELECT SubjectName FROM Subjects WHERE SubjectName='Bangla')
---------------Finding Out The Records Where A particualr Name NOT EXISTS--------------------
SELECT CONCAT(StudentName,'-',SubjectName) AS NameWithSubject
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
WHERE NOT EXISTS (SELECT StudentName FROM Students WHERE StudentName='Cierra Newton')
------------------JOIN Query to Find Out Subject Name ANY Of The Subject Named Math----------
SELECT StudentName,SubjectName,SportName
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
WHERE SubjectName=ANY(SELECT SubjectName FROM Subjects WHERE SubjectName='Math')
----------------------------Having Sport Name Some of the sportname---------------------------
SELECT StudentName,SubjectName,SportName
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
WHERE SportName=SOME(SELECT SportName FROM Sports)
------------------------Having Fees Greater than All Fees that were 200-----------------------
SELECT StudentName,SubjectName,SportName,Fees
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY StudentName,SubjectName,SportName,Fees
HAVING Fees>ALL(SELECT Fees FROM SportsDetails WHERE Fees=200)
-------------------------------------Casting 2020-01-01 as Date------------------------------
SELECT CAST ('2020-01-01' AS DATE) AS Dates
----------------------------Converting Current DateTime into DateTime -----------------------
SELECT CONVERT(DATETIME,GETDATE()) AS CurrentDateTime
-------------------------------------JOIN TABLE TO Show All Records -------------------------
SELECT Students.StudentName,Subjects.SubjectName,Sports.Fees,Fields 
FROM Students 
INNER JOIN SportsDetails ON Students.StudentRoll=SportsDetails.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
-------------------------------------JOIN TABLE TO Show Students Wise Total Fee---------------
SELECT DISTINCT(Students.StudentName),SUM(Sports.Fees) AS TotalFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY Students.StudentName
----------------------------------LEFT JOIN TABLE TO Show Subject Wise Students----------------
SELECT Students.StudentName,Subjects.SubjectName 
FROM Students
LEFT JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
LEFT JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
LEFT JOIN Sports ON Sports.SportID=SportsDetails.SportID
----------------------------------RIGHT JOIN TABLE TO Show Subject Wise Total Fees--------------
SELECT DISTINCT(SubjectName),SUM(Fees) AS TotalFee
FROM Subjects
RIGHT JOIN SportsDetails ON SportsDetails.SubjectID=Subjects.SubjectID
RIGHT JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY SubjectName
-----------------------------------Using WHERE AND HAVING To Filter Subject Math----------------
SELECT DISTINCT(Students.StudentName),Subjects.SubjectName,SUM(Sports.Fees) AS TotalFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
WHERE SubjectName='Math'
GROUP BY Students.StudentName,SubjectName
HAVING SUM(Sports.Fees)>600
-------------------------- Finding Out Specific Subject Record Using IN------------------------
SELECT DISTINCT(Students.StudentName),Subjects.SubjectName,SUM(Sports.Fees) AS TotalFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
WHERE SubjectName IN('Math','Bangla','English')
GROUP BY StudentName,SubjectName
-------------------------Sorting The Result Set Using RowNumber Function------------------------
SELECT SubjectName,ROW_NUMBER()OVER(ORDER BY SubjectName) 
FROM Subjects
---Sorting The Result Set Using Ranking Function To See Lowest to Highes Sports Fee-------------
SELECT Fees,RANK()OVER(ORDER BY Fees) 
FROM Sports
---Using DENSE_RANK Function To Sorting Subject Wise Fees---------------------------------------
SELECT StudentName,SubjectName,Fees,DENSE_RANK()OVER(ORDER BY SubjectName) AS DenseRanked
FROM SportsDetails
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
INNER JOIN Students ON SportsDetails.StudentRoll=Students.StudentRoll
---Using NTILE To Devide The Whole Subjects Into Two Groups-------------------------------------
SELECT StudentName,SubjectName,NTILE(2)OVER(ORDER BY SubjectName) AS TwoGroups
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Subjects ON Subjects.SubjectID=SportsDetails.SubjectID
-------------FIRST_VALUE And LAST_VALUE to Find Out 1st Playground and Last Playground
SELECT FIRST_VALUE(Fields)OVER(ORDER BY Fields) AS FirstFieldNo,LAST_VALUE(Fields)OVER(ORDER BY Fields DESC) AS LastFieldNo
FROM SportsDetails
----Using PARCENT_RANK,CUME_DIST,PERCENTILE_COUNT,PERCENTIEL_DISC To Find out Analytics Based On Fees and Subject Name
SELECT SubjectName,StudentName,Fees,Fields,
PERCENT_RANK()OVER(PARTITION BY Fees ORDER BY SubjectName) AS PercentRank,
CUME_DIST()OVER(PARTITION BY Fees ORDER BY SubjectName) AS CumeDist,
PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY Fees)OVER(PARTITION BY SubjectName) AS PercentileCount,
PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY Fees)OVER(PARTITION BY SubjectName) AS PercentitleDisc
FROM Subjects
INNER JOIN SportsDetails ON Subjects.SubjectID=SportsDetails.SubjectID
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
INNER JOIN Students ON SportsDetails.StudentRoll=Students.StudentRoll
-----------Using LAG And LEAD Function to Find Out the Previous Fees and Leading Fees-----------
SELECT Fees,LAG(Fees,1,0)OVER(ORDER BY Fees) AS PreviousValue,LEAD(Fees,1,0)OVER(ORDER BY Fees) AS LeadingValues
FROM Sports
-------------------------- Finding Out Specific Student Name Record Using Like------------------
SELECT StudentRoll,StudentName
FROM Students
WHERE StudentName LIKE ('Brittany%')
--Using Correlated SubQuery to Find Out Students whose fees were greater than the average fee--
SELECT Students.StudentRoll, StudentName, Fees
FROM Students INNER JOIN SportsDetails ON Students.StudentRoll=SportsDetails.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
WHERE Fees > 
(SELECT AVG(Fees)
FROM Sports AS AvgFee WHERE Sports.SportID=SportsDetails.SportID) 
-------------------------- Using CTE To Find Out Student Wise Fees---------------------------
WITH Fee_CTE AS
(
SELECT DISTINCT(Students.StudentName),SUM(Sports.Fees) AS TotalFee
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY Students.StudentName
)
SELECT * FROM Fee_CTE
-------------------------- Using A Recursive CTE --------------------------------------------
Go
WITH cte_numbers(n, weekday)
AS
(
SELECT 0,DATENAME(DW, 0)
UNION ALL SELECT  
n + 1, DATENAME(DW, n + 1)
FROM cte_numbers 
WHERE n < 6
)
SELECT weekday FROM cte_numbers;
-------------------USING IFF To Find fees that were over 600 as High fee others as LegalFee----
SELECT DISTINCT(Students.StudentName),SUM(Sports.Fees) AS TotalFee,
IIF(SUM(Sports.Fees)>600,'HighFee','LegalFee') AS FeeDistribution
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
GROUP BY Students.StudentName
-------------------------------------Using CHOOSE to Show the time to Prepare the fields--------
SELECT SportsDetails.Fields,
CHOOSE(SportsDetails.Fields,'10Days','20Days','15Days','15Days') AS TimetoPrepare
FROM SportsDetails
GROUP BY SportsDetails.Fields
-------------------------------------Using CASE to Find Out Venue-------------------------------
SELECT DISTINCT(Students.StudentName),Fields,
CASE Fields
WHEN 1 THEN 'Home'
WHEN 2 THEN 'Home'
Else 'Away'
END AS Venue
FROM Students
INNER JOIN SportsDetails ON SportsDetails.StudentRoll=Students.StudentRoll
INNER JOIN Sports ON Sports.SportID=SportsDetails.SportID
-------------------------------------Using Coalesce to Substitute NULL Values---------------------
SELECT COUNT(SportsDetails.StudentRoll) AS TotalParticipant ,COALESCE(SportsDetails.SportID,'99') AS 'Substituted',COALESCE(Sports.SportName,'99') AS 'Substituted99'
FROM SportsDetails
INNER JOIN Sports ON SportsDetails.SportID=Sports.SportID
GROUP BY GROUPING SETS(SportsDetails.SportID,Sports.SportName)
-------------------------------------Using Merge to Create a Backup-------------------------------
MERGE INTO MergedStudentsInfo AS M
USING Students AS S
ON S.StudentRoll=M.StudentRoll
WHEN MATCHED THEN
UPDATE SET M.StudentRoll=S.StudentRoll
WHEN NOT MATCHED THEN
INSERT (StudentRoll) VALUES (S.StudentRoll);
SELECT * FROM MergedStudentsInfo
SELECT * FROM Students
-------------------------------------Using Union to Show Collective Result-------------------------
SELECT StudentRoll,StudentName
FROM Students
UNION ALL
SELECT StudentRoll,StudentName 
FROM MergedStudentsInfo









-------------------------------------------------------------------------------------------------------END OF DML--------------------------------------------------------------------------------------------------

