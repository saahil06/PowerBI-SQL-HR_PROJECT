CREATE DATABASE HR;
USE HR;

ALTER TABLE `human resources`
CHANGE ï»¿id id VARCHAR(20);

-- updating the birthdate column and handling missing values

SELECT birthdate from  `human resources`;

SET SQL_SAFE_UPDATES=0;
UPDATE `human resources`
SET birthdate=CASE
					WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d') 
                    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
                    ELSE NULL
                    END ;

-- chaning datatype of birthdate

ALTER TABLE `human resources`
MODIFY column birthdate DATE;

SELECT hire_date FROM `human resources`;

UPDATE `human resources`
SET hire_date=CASE
					WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
					WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
					ELSE NULL
                    END;
                    
 ALTER TABLE `human resources`
 MODIFY COLUMN hire_date DATE;

-- ALTERING column termdate and setting null values insted of black space

SELECT termdate FROM `human resources`;

UPDATE `human resources`
SET termdate=DATE(STR_TO_DATE(termdate,'%Y-%m-%d %H'))
WHERE termdate is NULL AND termdate ="";

ALTER TABLE `human resources`
MODIFY COLUMN termdate DATE ;

-- Adding age column

ALTER TABLE `human resources`
ADD COLUMN age INT;

-- adding data to age column
UPDATE `human resources`
SET age =timestampdiff(YEAR,birthdate,CURDATE());

SELECT age from `human resources`;

-- handling the negative values from the age column

UPDATE `human resources`
SET age= CASE WHEN age<0 THEN abs(age)
ELSE age
END;