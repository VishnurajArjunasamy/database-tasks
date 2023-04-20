-- 1)Write a SQL query to remove the details of an employee whose first name ends in ‘even

    delete from employees where lower(FIRST_NAME) like '%even';

-- 2)Write a query in SQL to show the three minimum values of the salary from the table.
    select SALARY from employees 
    order by salary
    limit 3;

-- 3)Write a SQL query to remove the employees table from the database
    drop table employees;

--4)Write a SQL query to copy the details of this table into a new table with table name as Employee 
-- table and to delete the records in employees table
    create table Employee_table as select * from employees;
    --create table employee_table clone employees
    
    select * from Employee_table;
    truncate table employees;

--5. Write a SQL query to remove the column Age from the table
    ALTER table EMPLOYEE_TABLE Add Age Int;
    
    ALTER table EMPLOYEE_TABLE Drop column Age;

--6)Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
    select concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME,email,HIRE_DATE from EMPLOYEE_TABLE
    where year(HIRE_DATE) <2000;

--7)Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
    select employee_id,job_id from EMPLOYEE_TABLE
    where year(HIRE_DATE) between 1990 and 1999;
    

--8)Find the first occurrence of the letter 'A' in each employees Email ID
--  Return the employee_id, email id and the letter position
    select employee_id,email,  regexp_instr(EMAIL,'A') as letter_position from EMPLOYEE_TABLE
    where letter_position>0;

--9)Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
    select Employee_id,concat(FIRST_NAME,' ',LAST_NAME) as FULL_NAME,email from EMPLOYEE_TABLE
    where LEN(concat(FIRST_NAME,' ',LAST_NAME))<12;

--10)Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID
--   Return the employee_id, and their corresponding UNQ_ID
    select employee_id, concat_ws('-',FIRST_NAME,LAST_NAME,EMAIL) as UNQ_ID from EMPLOYEE_TABLE;

--11) Write a SQL query to update the size of email column to 30
    ALTER table EMPLOYEE_TABLE 
    MODIFY COLUMN email varchar(30);

--12)Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)
--   Info : this mean you need to separate phone into 2 parts
--   eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
    select FIRST_NAME,EMAIL,array_to_string(array_slice(SPLIT(PHONE_NUMBER,'.'),0,array_size(SPLIT(PHONE_NUMBER,'.'))-1),'.') as phone,         array_to_string(array_slice(SPLIT(PHONE_NUMBER,'.'),-1,array_size(SPLIT(PHONE_NUMBER,'.'))),'')  as extension from EMPLOYEE_TABLE;

--13)Write a SQL query to find the employee with second and third maximum salary
    select *from EMPLOYEE_TABLE
    where salary in(select distinct salary from employees)
    order by salary desc
    limit 2 offset 1;

--14)Fetch all details of top 3 highly paid employees who are in department Shipping and IT 
    select * from employee_table e
    join departments d on d.department_id = e.department_id
    where d.department_name in( 'Shipping', 'IT')
    order by salary desc
    limit 3;

--15) Display employee id and the positions(jobs) held by that employee (including the current position)
    select * from JOB_HISTORY;
    
    select EMPLOYEE_TABLE.employee_id , EMPLOYEE_TABLE.job_id from EMPLOYEE_TABLE union select employee_id , job_id  from job_history
    order by employee_id;

--16)Display Employee first name and date joined as WeekDay, Month Day, Year
    select first_name, concat(dayname(HIRE_DATE),',',monthname(HIRE_DATE),' ',Day(HIRE_DATE),',',year(HIRE_DATE)) as Date_Joined from EMPLOYEE_TABLE;

--17)The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 . The job position       might be removed based on market trends (so, save the changes).
    alter session set autocommit = false;
    
    begin transaction;
    insert into jobs values('DT_ENGG','Data Engineer',12000,30000);
    commit;
    select * from jobs;
    -- Later, update the maximum salary to 40,000 .
    update jobs 
    set MAX_SALARY=40000
    where JOB_ID='DT_ENGG';
    --Now, revert back the changes to the initial state, where the salary was 30,000
    rollback;

--18)Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
    select round(avg(salary),3) from employee_table
    where HIRE_DATE>to_date('1996-01-08') and HIRE_DATE<to_date('2000-01-01');

--19)Display Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
--A. Display all the regions
    select region_name from regions union all  select('Australia') union all select('Asia') union all select('Europe') union all select('Antartica');
--B. Display all the unique regions
    select region_name from regions union   select('Australia') union  select('Asia') union  select('Europe') union  select('Antartica');
    
