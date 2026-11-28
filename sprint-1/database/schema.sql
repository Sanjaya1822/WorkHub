create database WorkHubDB;
use WorkHubDB;

show databases;

create table Plant (
    PlantID int primary key auto_increment,
    PlantName varchar(100) not null,
    City varchar(50) not null
);

create table Department (
    DepartmentID int primary key auto_increment,
    DepartmentName varchar(100) not null,
    PlantID int,
    foreign key (PlantID) references Plant(PlantID)
);

desc Plant;
desc Department;

create table Employee (
    EmployeeID int primary key auto_increment,
    FirstName varchar(50) not null,
    LastName varchar(50) not null,
    Email varchar(100) unique not null,
    DepartmentID int,
    ManagerID int,
    HireDate date,
    Salary decimal(12,2) check (Salary >= 0),

    foreign key (DepartmentID)
        references Department(DepartmentID),

    foreign key (ManagerID)
        references Employee(EmployeeID)
);
desc Employee;


create table LeaveRequest (
    LeaveID int primary key auto_increment,
    EmployeeID int,
    LeaveType varchar(30),
    StartDate date,
    EndDate date,
    Status varchar(20) default 'Pending',

    foreign key (EmployeeID)
        references Employee(EmployeeID)
);

create table Timesheet (
    TimesheetID int primary key auto_increment,
    EmployeeID int,
    WorkDate date,
    HoursWorked decimal(4,2) check (HoursWorked >= 0),
    OvertimeHours decimal(4,2) default 0,

    foreign key (EmployeeID)
        references Employee(EmployeeID)
);

create table PerformanceReview (
    ReviewID int primary key auto_increment,
    EmployeeID int,
    ReviewerID int,
    ReviewDate date,
    Rating int check (Rating between 1 and 5),
    Comments varchar(500),

    foreign key (EmployeeID)
        references Employee(EmployeeID),

    foreign key (ReviewerID)
        references Employee(EmployeeID)
);


insert into Plant (PlantName, City) values
('Main Plant', 'Chennai'),
('North Plant', 'Delhi'),
('South Plant', 'Coimbatore'),
('West Plant', 'Mumbai'),
('East Plant', 'Kolkata'),
('Central Plant', 'Bhopal'),
('Tech Plant', 'Bangalore'),
('Industrial Plant', 'Hyderabad'),
('Manufacturing Plant', 'Pune'),
('Production Plant', 'Jaipur');

insert into Department (DepartmentName, PlantID) values
('Human Resources', 1),
('Information Technology', 2),
('Finance', 3),
('Marketing', 4),
('Sales', 5),
('Production', 6),
('Quality Control', 7),
('Administration', 8),
('Research and Development', 9),
('Operations', 10);

insert into Employee
(FirstName, LastName, Email, DepartmentID, ManagerID, HireDate, Salary)
values
('Arun', 'Kumar', 'arun@workhub.com', 1, null, '2022-01-10', 60000),
('Priya', 'Sharma', 'priya@workhub.com', 2, null, '2022-03-15', 55000),
('Rahul', 'Raj', 'rahul@workhub.com', 3, null, '2021-06-20', 65000),
('Divya', 'Ravi', 'divya@workhub.com', 4, null, '2023-02-12', 40000),
('Karthik', 'S', 'karthik@workhub.com', 5, null, '2023-04-18', 42000),
('Meena', 'Devi', 'meena@workhub.com', 6, null, '2022-08-25', 45000),
('Vijay', 'Kumar', 'vijay@workhub.com', 7, null, '2021-11-05', 50000),
('Sneha', 'R', 'sneha@workhub.com', 8, null, '2023-07-10', 38000),
('Ajay', 'M', 'ajay@workhub.com', 9, null, '2022-09-14', 48000),
('Nithya', 'S', 'nithya@workhub.com', 10, null, '2024-01-08', 35000);

update Employee set ManagerID = 1 where EmployeeID in (2, 3);

update Employee set ManagerID = 2 where EmployeeID in (4, 5);

update Employee set ManagerID = 3 where EmployeeID in (6, 7);

update Employee set ManagerID = 4 where EmployeeID in (8, 9, 10);

insert into LeaveRequest
(EmployeeID, LeaveType, StartDate, EndDate, Status)
values
(1, 'Casual', '2026-01-05', '2026-01-06', 'Approved'),
(2, 'Sick', '2026-01-10', '2026-01-11', 'Pending'),
(3, 'Earned', '2026-01-15', '2026-01-17', 'Approved'),
(4, 'Casual', '2026-02-01', '2026-02-02', 'Rejected'),
(5, 'Sick', '2026-02-05', '2026-02-06', 'Pending'),
(6, 'Earned', '2026-02-10', '2026-02-12', 'Approved'),
(7, 'Casual', '2026-03-01', '2026-03-02', 'Pending'),
(8, 'Sick', '2026-03-05', '2026-03-06', 'Approved'),
(9, 'Earned', '2026-03-10', '2026-03-12', 'Rejected'),
(10, 'Casual', '2026-03-15', '2026-03-16', 'Pending');

delimiter //

create procedure insert_timesheets()
begin
    declare i int default 1;

    while i <= 200 do

        insert into Timesheet
        (EmployeeID, WorkDate, HoursWorked, OvertimeHours)
        values (
            mod(i - 1, 10) + 1,
            date_add('2026-01-01', interval floor((i - 1) / 10) day),
            8.00,
            0.00
        );

        set i = i + 1;

    end while;
end //

delimiter ;

call insert_timesheets();

insert into PerformanceReview
(EmployeeID, ReviewerID, ReviewDate, Rating, Comments)
values
(1, 2, '2026-03-01', 5, 'Excellent performance'),
(2, 1, '2026-03-02', 4, 'Very good performance'),
(3, 1, '2026-03-03', 5, 'Outstanding work'),
(4, 2, '2026-03-04', 3, 'Good performance'),
(5, 2, '2026-03-05', 4, 'Consistent work'),
(6, 3, '2026-03-06', 5, 'Excellent contribution'),
(7, 3, '2026-03-07', 4, 'Good teamwork'),
(8, 4, '2026-03-08', 3, 'Needs improvement'),
(9, 4, '2026-03-09', 5, 'Excellent results'),
(10, 4, '2026-03-10', 4, 'Good performance');

select *from plant;
select *from department;
select *from employee;
select *from Timesheet;
select *from performancereview;
select *from leaverequest;

-- Test UNIQUE constraint by inserting a duplicate email
-- Expected: Duplicate entry error
INSERT INTO Employee
(FirstName, LastName, Email, DepartmentID, ManagerID, HireDate, Salary)
VALUES
('Test2', 'User2', 'testuser@gmail.com', 1, NULL, '2026-01-01', 30000);


-- Test CHECK constraint by inserting a negative salary
-- Expected: Check constraint error
INSERT INTO Employee
(FirstName, LastName, Email, DepartmentID, ManagerID, HireDate, Salary)
VALUES
('Bala', 'Kumar', 'bala_test@gmail.com', 1, NULL, '2026-01-01', -5000);


-- Test FOREIGN KEY constraint using a non-existing EmployeeID
-- Expected: Foreign key constraint error
INSERT INTO LeaveRequest
(EmployeeID, LeaveType, StartDate, EndDate, Status)
VALUES
(9999, 'Medical', '2026-03-01', '2026-03-02', 'Pending');

