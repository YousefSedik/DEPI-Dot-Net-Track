-- create database marketplace;

create table user_status (
    id int primary key identity(1,1),
    [status] varchar(50)
);

create table countries (
    id int primary key identity(1,1),
    country_name varchar(50)
);


create table users (
    id int primary key identity(1,1),
    username varchar(50),
    email varchar(50),
    password_hash varchar(50),
    [status] int foreign key references user_status(id),
    address_line1 varchar(50),
    address_line2 varchar(50),
    city varchar(50),
    [state] varchar(50),
    postal_code varchar(50),
    countryID int foreign key references countries(id),
    create_at datetime default getdate()
);


create table categories (
    id int primary key identity(1,1),
    category_name varchar(50), 
    description varchar(50)
);


create table items(
    id int primary key identity(1,1),
    seller_id int foreign key references users(id),
    
category_id int foreign key references categories(id),
    title varchar(50),
    [description] varchar(50),
    starting_price decimal(10,2),
    current_price decimal(10,2),
    [start_date] datetime,
    price decimal(10,2),
    create_at datetime default getdate()
);

create table bids(
    id int primary key identity(1,1),
    item_id int foreign key references items(id),
    user_id int foreign key references users(id),
    bid_amount decimal(10,2),
    bid_time datetime default getdate()
);

create table orders(
    id int primary key identity(1,1),
    buyer_id int foreign key references users(id),
    item_id int foreign key references items(id),
    order_date datetime default getdate(),
    total_amount decimal(10,2)
);

create table [notification](
    id int primary key identity(1,1),
    user_id int foreign key references users(id),
    [message] varchar(50),
    is_read bit default 0,
    created_at datetime default getdate() 
);

select item.*, [user].*
from items item
join users [user] on item.seller_id = [user].id

select [user].*, item.*
from users [user]
left outer join items item on [user].id = item.seller_id

select [user].* 
from users [user]
full outer join items item on [user].id = item.seller_id


select item.id, count(bids.id) as total_bids
from items item 
left outer join bids on item.id = bids.item_id
group by item.id

select [user].id, sum([order].total_amount) as total_amount 
from users [user]
left outer join orders [order] on [user].id = [order].buyer_id
group by [user].id

select 
	items.*, cat.*
from 
	items
join 
	categories as cat 
on 
	cat.id = items.category_id