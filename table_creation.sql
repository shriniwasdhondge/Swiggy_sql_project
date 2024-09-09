create table User1(
	 user_id int primary key,	
	 name varchar(10),	
	 email varchar(16),
	 password varchar(10)

);
create table restaurants(
	r_id int primary key,	
	r_name varchar(20),
	cuisine varchar(10),
	city varchar(10)
)

create table orders(
	order_id int primary key, 
	user_id int, 		--this is coming from user1 table
	r_id int, 			--this is coming from resturants table
	amount float,
	order_date date,
	partner_id int, 		--this is coming from riders table
	delivery_time int, 
	delivery_rating float,
	restaurant_rating float
)
--adding fK constraints
alter table orders
add constraint fk_user
foreign key (user_id)
references user1(user_id)


--adding fK constraints
alter table orders
add constraint fk_restaurants
foreign key (r_id)
references restaurants(r_id)

create table riders(
	partner_id int primary key,				
	partner_name varchar(10)
)
--adding fK constraints
alter table orders
add constraint fk_ride_id
foreign key (partner_id)
references riders(partner_id)

create table order_details(
	p_id int primary key,
	order_id int,	--this is coming from orders table
	f_id int,		--this is coming from food table
	delivery_status varchar(10)
	
)
--adding fK constraints
alter table order_details
add constraint fk_order_id
foreign key (order_id)
references orders(order_id)

--adding fK constraints
alter table order_details
add constraint fk_food
foreign key (f_id)
references food(f_id)

create table food(
	f_id int primary key,
	f_name varchar(15),
	f_type varchar(10)
	
)
create table delivery_partner(
partner_id int, 
partner_name varchar(15)
)

--data importing is done by
--1.right click on the table created at schemas in your database
--go to import/export data
--browse and give the file location where you have downloaded the csv file
