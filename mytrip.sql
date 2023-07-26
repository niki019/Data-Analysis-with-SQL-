create table booking(
id varchar(50),
booking_date date not null,
line_of_business varchar(50),
user_id varchar(50));

Insert into booking(id, booking_date, line_of_business,user_id)
values("b1", "2022-03-23","Flight","u1"),
	  ("b2", "2022-03-27","Flight","u2"),
      ("b3", "2022-03-28","Hotel","u1"),
      ("b4", "2022-03-31","Flight","u4"),
      ("b5", "2022-04-02","Hotel","u1"),
      ("b6", "2022-04-06","Flight","u2"),
      ("b7", "2022-04-06","Flight","u5"),
      ("b8", "2022-04-06","Hotel","u6"),
      ("b9", "2022-04-06","Flight","u2"),
	  ("b10", "2022-04-10","Flight","u1"),
      ("b11", "2022-04-12","Flight","u4"),
      ("b12", "2022-04-16","Flight","u1"),
      ("b13", "2022-04-19","Flight","u2"),
      ("b14", "2022-04-20","Hotel","u5"),
      ("b15", "2022-04-22","Flight","u6"),
      ("b16", "2022-04-26","Hotel","u4"),
      ("b17", "2022-04-28","Hotel","u2"),
      ("b18", "2022-04-30","Hotel","u1"),
      ("b19", "2022-05-04","Hotel","u4"),
      ("b20", "2022-05-06","Flight","u1");

create table user_table(
user_id varchar(50),
segment varchar(50));

Insert into user_table(user_id, segment)
values("u1","s1"),
      ("u2","s1"),
      ("u3","s1"),
      ("u4","s2"),
      ("u5","s2"),
      ("u6","s3"),
      ("u7","s3"),
      ("u8","s3"),
      ("u9","s3"),
      ("u10","s3");
    
/*find out the total users who booked flights in April 2022*/
select count(*) as total
from (select  monthname(booking_date) as months, line_of_business
from booking) as aluu
where months="April" AND line_of_business="Flight";

select ut.segment,
count(distinct(ut.user_id)) as total_user_count,
count(distinct(
      case when year(booking_date) = 2022 AND month(booking_date) = 4
      and line_of_business = "Flight" Then ut.user_id end))
      AS user_who_booked_flight_in_apr2022
from user_table ut
left join booking bt
on ut.user_id = bt.user_id
group by ut.segment;

/*find the users whose first booking was a hotel booking*/
with cte as (select *, rank() over(partition by user_id order by booking_date) as booking_rank
from booking)
select distinct(user_id)
from cte
where booking_rank=1 and line_of_business="Hotel";

/*find the days between the first booking and the last booking for each user*/
select user_id, datediff(max(booking_date), min(booking_date)) as days_diff
from booking
group by user_id
order by days_diff;

/*count the number of flights aand hotel bookings for each user segment in 2022*/
select segment, sum(case when line_of_business= "Flight" then 1 else 0 end) as flight_bookings,sum(case when line_of_business="Hotel" then 1 else 0 end) as Hotel_bookings
from user_table ut
inner join booking bt
 on ut.user_id=bt.user_id
 where year(booking_date) = 2022
 group by segment;

         
