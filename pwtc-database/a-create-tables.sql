/*** Create tables ***/

create table if not exists pwtc_membership (member_id VARCHAR(5) NOT NULL, last_name TEXT NOT NULL, first_name TEXT NOT NULL, expir_date DATE NOT NULL, constraint pk_pwtc_membership PRIMARY KEY (member_id));

create table if not exists pwtc_club_rides (ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, title TEXT NOT NULL, date DATE NOT NULL, post_id BIGINT UNSIGNED, constraint pk_pwtc_club_rides PRIMARY KEY (ID)); 

create table if not exists pwtc_ride_mileage (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, mileage INT UNSIGNED NOT NULL, constraint pk_pwtc_ride_mileage PRIMARY KEY (member_id, ride_id), constraint fk_pwtc_ride_mileage_member_id FOREIGN KEY (member_id) REFERENCES pwtc_membership (member_id), constraint fk_pwtc_ride_mileage_ride_id FOREIGN KEY (ride_id) REFERENCES pwtc_club_rides (ID));

create table if not exists pwtc_ride_leaders (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, rides_led INT UNSIGNED NOT NULL, constraint pk_pwtc_ride_leaders PRIMARY KEY (member_id, ride_id), constraint fk_pwtc_ride_leaders_member_id FOREIGN KEY (member_id) REFERENCES pwtc_membership (member_id), constraint fk_pwtc_ride_leaders_ride_id FOREIGN KEY (ride_id) REFERENCES pwtc_club_rides (ID));

/*** Create views ***/

/* View to list lifetime mileage for all club members */
create or replace view pwtc_lt_miles_vw (member_id, first_name, last_name, mileage) as select c.member_id, c.first_name, c.last_name, SUM(m.mileage) from pwtc_membership as c inner join pwtc_ride_mileage as m on c.member_id = m.member_id group by m.member_id;

/* View to list year-to-date mileage for all club members */
create or replace view pwtc_ytd_miles_vw (member_id, first_name, last_name, mileage) as select c.member_id, c.first_name, c.last_name, SUM(m.mileage) from ((pwtc_ride_mileage as m inner join pwtc_membership as c on c.member_id = m.member_id) inner join pwtc_club_rides as r on m.ride_id = r.ID) where r.date >= DATE_FORMAT(CURDATE(), '%Y-01-01') group by m.member_id;

/* View to list last year's mileage for all club members */
create or replace view pwtc_ly_miles_vw (member_id, first_name, last_name, mileage) as select c.member_id, c.first_name, c.last_name, SUM(m.mileage) from ((pwtc_ride_mileage as m inner join pwtc_membership as c on c.member_id = m.member_id) inner join pwtc_club_rides as r on m.ride_id = r.ID) where r.date between DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') and DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') group by m.member_id;

/* View to list last year's lifetime mileage for all club members */
create or replace view pwtc_ly_lt_miles_vw (member_id, first_name, last_name, mileage) as select c.member_id, c.first_name, c.last_name, SUM(m.mileage) from ((pwtc_ride_mileage as m inner join pwtc_membership as c on c.member_id = m.member_id) inner join pwtc_club_rides as r on m.ride_id = r.ID) where r.date < DATE_FORMAT(CURDATE(), '%Y-01-01') group by m.member_id;

/* View to list year before last lifetime mileage for all club members */
create or replace view pwtc_ybl_lt_miles_vw (member_id, first_name, last_name, mileage) as select c.member_id, c.first_name, c.last_name, SUM(m.mileage) from ((pwtc_ride_mileage as m inner join pwtc_membership as c on c.member_id = m.member_id) inner join pwtc_club_rides as r on m.ride_id = r.ID) where r.date < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') group by m.member_id;

/* View to list 10K lifetime mileage achievement milestones for all club members */
create or replace view pwtc_ly_lt_achvmnt_vw (member_id, first_name, last_name, mileage, achievement) as select a.member_id, a.first_name, a.last_name, a.mileage, concat(floor(a.mileage/10000),'0K') from pwtc_ly_lt_miles_vw a inner join pwtc_ybl_lt_miles_vw b on a.member_id = b.member_id where floor(a.mileage/10000) > floor(b.mileage/10000);

/* View to list YTD rides led by all club members */
create or replace view pwtc_ytd_rides_led_vw (title, date, member_id) as select r.title, r.date, l.member_id from pwtc_club_rides as r inner join pwtc_ride_leaders as l on r.ID = l.ride_id where r.date >= DATE_FORMAT(CURDATE(), '%Y-01-01') order by r.date;

/* View to list last year's rides led by all club members */
create or replace view pwtc_ly_rides_led_vw (title, date, member_id) as select r.title, r.date, l.member_id from pwtc_club_rides as r inner join pwtc_ride_leaders as l on r.ID = l.ride_id where r.date between DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') and DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') order by r.date;

/* View to list lifetime number of rides led for all club members */
/*
create view pwtc_lifetime_num_rides_led_vw (member_id, first_name, last_name, rides_led) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_leaders.rides_led) from pwtc_membership inner join pwtc_ride_leaders on pwtc_membership.member_id = pwtc_ride_leaders.member_id group by pwtc_ride_leaders.member_id;
*/

/* View to list year-to-date number of rides led for all club members */
create or replace view pwtc_ytd_led_vw (member_id, first_name, last_name, rides_led) as select c.member_id, c.first_name, c.last_name, SUM(l.rides_led) from ((pwtc_ride_leaders as l inner join pwtc_membership as c on c.member_id = l.member_id) inner join pwtc_club_rides as r on l.ride_id = r.ID) where r.date >= DATE_FORMAT(CURDATE(), '%Y-01-01') group by l.member_id;

/* View to list last year's number of rides led for all club members */
create or replace view pwtc_ly_led_vw (member_id, first_name, last_name, rides_led) as select c.member_id, c.first_name, c.last_name, SUM(l.rides_led) from ((pwtc_ride_leaders as l inner join pwtc_membership as c on c.member_id = l.member_id) inner join pwtc_club_rides as r on l.ride_id = r.ID) where r.date between DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') and DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') group by l.member_id;

/* View to list year-to-date rides ridden by club members */
create or replace view pwtc_ytd_rides_vw (title, date, mileage, member_id) as select r.title, r.date, m.mileage, m.member_id from pwtc_club_rides as r inner join pwtc_ride_mileage as m on r.ID = m.ride_id where r.date >= DATE_FORMAT(CURDATE(), '%Y-01-01') order by r.date;

/* View to list last year's rides ridden by club members */
create or replace view pwtc_ly_rides_vw (title, date, mileage, member_id) as select r.title, r.date, m.mileage, m.member_id from pwtc_club_rides as r inner join pwtc_ride_mileage as m on r.ID = m.ride_id where r.date between DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') and DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') order by r.date;