-- =========================================================
-- CUSTOMERS
-- =========================================================

create table customers (
    customer_id int primary key,
    customer_name varchar(100),
    gender varchar(10),
    city varchar(50),
    signup_date date
);

insert into customers values
(1,'Rahul','Male','Mumbai','2023-01-10'),
(2,'Aman','Male','Delhi','2023-01-15'),
(3,'Priya','Female','Pune','2023-02-01'),
(4,'Sneha','Female','Bangalore','2023-02-11'),
(5,'Rohit','Male','Hyderabad','2023-03-01'),
(6,'Neha','Female','Mumbai','2023-03-20'),
(7,'Karan','Male','Delhi','2023-04-05'),
(8,'Simran','Female','Pune','2023-04-15'),
(9,'Vikas','Male','Chennai','2023-05-01'),
(10,'Anjali','Female','Kolkata','2023-05-18'),
(11,'Arjun','Male','Ahmedabad','2023-06-01'),
(12,'Pooja','Female','Mumbai','2023-06-12');



-- =========================================================
-- PRODUCTS
-- =========================================================

create table products (
    product_id int primary key,
    product_name varchar(100),
    category varchar(50),
    price numeric(10,2)
);

insert into products values
(101,'Laptop','Electronics',75000),
(102,'Mobile','Electronics',30000),
(103,'Keyboard','Electronics',2000),
(104,'Mouse','Electronics',1000),
(105,'Headphones','Electronics',2500),
(106,'Chair','Furniture',6000),
(107,'Table','Furniture',8000),
(108,'Shoes','Fashion',4000),
(109,'T-Shirt','Fashion',1500),
(110,'Watch','Accessories',7000),
(111,'Bag','Accessories',3500),
(112,'Bottle','Lifestyle',700);



-- =========================================================
-- ORDERS
-- =========================================================

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    status varchar(20),
    foreign key (customer_id) references customers(customer_id)
);

insert into orders values
(1001,1,'2023-06-01','Completed'),
(1002,2,'2023-06-02','Completed'),
(1003,3,'2023-06-05','Cancelled'),
(1004,1,'2023-06-10','Completed'),
(1005,4,'2023-06-12','Pending'),
(1006,5,'2023-06-15','Completed'),
(1007,6,'2023-06-18','Completed'),
(1008,7,'2023-06-20','Completed'),
(1009,8,'2023-06-25','Cancelled'),
(1010,2,'2023-07-01','Completed'),
(1011,3,'2023-07-03','Completed'),
(1012,4,'2023-07-05','Completed'),
(1013,5,'2023-07-08','Pending'),
(1014,6,'2023-07-10','Completed'),
(1015,1,'2023-07-15','Completed'),
(1016,9,'2023-07-18','Completed'),
(1017,10,'2023-07-20','Completed'),
(1018,11,'2023-07-21','Completed'),
(1019,12,'2023-07-23','Completed'),
(1020,1,'2023-08-01','Completed'),
(1021,2,'2023-08-03','Completed'),
(1022,3,'2023-08-05','Completed'),
(1023,4,'2023-08-08','Completed'),
(1024,5,'2023-08-12','Completed'),
(1025,6,'2023-08-15','Completed');



-- =========================================================
-- ORDER ITEMS
-- =========================================================

create table order_items (
    order_item_id int primary key,
    order_id int,
    product_id int,
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into order_items values
(1,1001,101,1),
(2,1001,103,2),
(3,1002,102,1),
(4,1002,104,1),
(5,1003,108,2),
(6,1004,101,1),
(7,1004,110,1),
(8,1005,106,1),
(9,1006,109,3),
(10,1006,111,1),
(11,1007,105,1),
(12,1008,107,1),
(13,1008,108,2),
(14,1009,109,1),
(15,1010,101,1),
(16,1010,102,1),
(17,1011,103,4),
(18,1011,110,1),
(19,1012,111,2),
(20,1013,106,1),
(21,1014,107,2),
(22,1014,104,3),
(23,1015,101,1),
(24,1015,109,2),
(25,1016,112,5),
(26,1017,108,2),
(27,1018,101,1),
(28,1018,105,2),
(29,1019,107,1),
(30,1020,102,1),
(31,1020,103,1),
(32,1021,104,2),
(33,1022,110,1),
(34,1023,111,1),
(35,1024,108,1),
(36,1025,101,1);



-- =========================================================
-- PAYMENTS
-- =========================================================

create table payments (
    payment_id int primary key,
    order_id int,
    payment_date date,
    amount numeric(10,2),
    payment_method varchar(20),
    foreign key (order_id) references orders(order_id)
);

insert into payments values
(1,1001,'2023-06-01',79000,'UPI'),
(2,1002,'2023-06-02',31000,'Card'),
(3,1004,'2023-06-10',82000,'NetBanking'),
(4,1006,'2023-06-15',8000,'UPI'),
(5,1007,'2023-06-18',2500,'Card'),
(6,1008,'2023-06-20',14000,'UPI'),
(7,1010,'2023-07-01',105000,'Card'),
(8,1011,'2023-07-03',15000,'UPI'),
(9,1012,'2023-07-05',7000,'UPI'),
(10,1014,'2023-07-10',19000,'NetBanking'),
(11,1015,'2023-07-15',78000,'Card'),
(12,1016,'2023-07-18',3500,'UPI'),
(13,1017,'2023-07-20',8000,'Card'),
(14,1018,'2023-07-21',80000,'UPI'),
(15,1019,'2023-07-23',8000,'Card'),
(16,1020,'2023-08-01',32000,'UPI'),
(17,1021,'2023-08-03',2000,'Card'),
(18,1022,'2023-08-05',7000,'UPI'),
(19,1023,'2023-08-08',3500,'Card'),
(20,1024,'2023-08-12',4000,'UPI'),
(21,1025,'2023-08-15',75000,'NetBanking');



-- =========================================================
-- WEBSITE ACTIVITY
-- =========================================================

create table user_activity (
    user_id int,
    session_id int,
    activity_date date,
    activity_type varchar(50)
);

insert into user_activity values
(1,101,'2023-07-01','login'),
(1,101,'2023-07-01','view_product'),
(1,101,'2023-07-01','purchase'),

(2,102,'2023-07-01','login'),
(2,102,'2023-07-01','logout'),

(3,103,'2023-07-02','login'),
(3,103,'2023-07-02','purchase'),

(1,104,'2023-07-03','login'),
(1,104,'2023-07-03','purchase'),

(4,105,'2023-07-03','login'),

(5,106,'2023-07-04','login'),
(5,106,'2023-07-04','view_product'),

(1,107,'2023-07-05','login'),
(1,107,'2023-07-05','logout'),

(2,108,'2023-07-05','login'),
(2,108,'2023-07-05','purchase'),

(3,109,'2023-07-06','login'),

(6,110,'2023-07-06','purchase'),

(7,111,'2023-07-07','login'),

(8,112,'2023-07-08','login'),

(9,113,'2023-07-09','purchase'),

(10,114,'2023-07-10','login');



-- =========================================================
-- EMPLOYEES
-- =========================================================

create table employees (
    emp_id int primary key,
    emp_name varchar(100),
    department varchar(50),
    manager_id int,
    salary numeric(10,2),
    joining_date date
);

insert into employees values
(1,'Amit','HR',null,95000,'2020-01-10'),
(2,'Ravi','IT',1,70000,'2021-02-15'),
(3,'Meena','IT',1,72000,'2021-03-10'),
(4,'Suresh','Finance',1,68000,'2021-04-12'),
(5,'Kiran','Finance',4,60000,'2022-01-01'),
(6,'Pooja','IT',2,65000,'2022-05-20'),
(7,'Arjun','Sales',1,55000,'2022-07-15'),
(8,'Nikita','Sales',7,50000,'2023-01-01'),
(9,'Deepak','Sales',7,52000,'2023-03-11'),
(10,'Varun','IT',2,64000,'2023-04-10');