/*** Create tables ***/

create table pwtc_membership (member_id VARCHAR(5) NOT NULL, last_name TEXT NOT NULL, first_name TEXT NOT NULL, expir_date DATE NOT NULL, constraint pk_pwtc_membership PRIMARY KEY (member_id));

create table pwtc_club_rides (ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, title TEXT NOT NULL, date DATE NOT NULL, post_id BIGINT UNSIGNED, constraint pk_pwtc_club_rides PRIMARY KEY (ID)); 

create table pwtc_ride_mileage (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, mileage INT UNSIGNED NOT NULL, constraint pk_pwtc_ride_mileage PRIMARY KEY (member_id, ride_id), constraint fk_pwtc_ride_mileage_member_id FOREIGN KEY (member_id) REFERENCES pwtc_membership (member_id), constraint fk_pwtc_ride_mileage_ride_id FOREIGN KEY (ride_id) REFERENCES pwtc_club_rides (ID));

create table pwtc_ride_leaders (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, rides_led INT UNSIGNED NOT NULL, constraint pk_pwtc_ride_leaders PRIMARY KEY (member_id, ride_id), constraint fk_pwtc_ride_leaders_member_id FOREIGN KEY (member_id) REFERENCES pwtc_membership (member_id), constraint fk_pwtc_ride_leaders_ride_id FOREIGN KEY (ride_id) REFERENCES pwtc_club_rides (ID));

/*** Create views ***/

/* View to list lifetime mileage for all club members */
create view pwtc_lifetime_mileage_vw (member_id, first_name, last_name, mileage) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_mileage.mileage) from pwtc_membership inner join pwtc_ride_mileage on pwtc_membership.member_id = pwtc_ride_mileage.member_id group by pwtc_ride_mileage.member_id;

/* View to list year-to-date mileage for all club members */
create view pwtc_ytd_mileage_vw (member_id, first_name, last_name, mileage) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_mileage.mileage) from ((pwtc_ride_mileage inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_mileage.member_id) inner join pwtc_club_rides on pwtc_ride_mileage.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.date >= DATE_FORMAT(CURDATE(), '%Y-01-01') group by pwtc_ride_mileage.member_id;

/* View to list last year's mileage for all club members */
create view pwtc_last_year_mileage_vw (member_id, first_name, last_name, mileage) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_mileage.mileage) from ((pwtc_ride_mileage inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_mileage.member_id) inner join pwtc_club_rides on pwtc_ride_mileage.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.date between DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') and DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') group by pwtc_ride_mileage.member_id;

/* View to list last year's lifetime mileage for all club members */
create view pwtc_last_year_lifetime_mileage_vw (member_id, first_name, last_name, mileage) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_mileage.mileage) from ((pwtc_ride_mileage inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_mileage.member_id) inner join pwtc_club_rides on pwtc_ride_mileage.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.date < DATE_FORMAT(CURDATE(), '%Y-01-01') group by pwtc_ride_mileage.member_id;

/* View to list year before last lifetime mileage for all club members */
create view pwtc_year_before_last_lifetime_mileage_vw (member_id, first_name, last_name, mileage) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_mileage.mileage) from ((pwtc_ride_mileage inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_mileage.member_id) inner join pwtc_club_rides on pwtc_ride_mileage.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.date < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') group by pwtc_ride_mileage.member_id;

/* View to list 10K lifetime mileage achievement milestones for all club members */
create view pwtc_last_year_lifetime_achievement_vw (member_id, first_name, last_name, mileage, achievement) as select a.member_id, a.first_name, a.last_name, a.mileage, concat(floor(a.mileage/10000),'0K') from pwtc_last_year_lifetime_mileage_vw a inner join pwtc_year_before_last_lifetime_mileage_vw b on a.member_id = b.member_id where floor(a.mileage/10000) > floor(b.mileage/10000);

/* View to list YTD rides ridden by all club members */
create view pwtc_ytd_rides_ridden_vw (title, date, member_id, mileage) as select pwtc_club_rides.title, pwtc_club_rides.date, pwtc_ride_mileage.member_id, pwtc_ride_mileage.mileage from pwtc_club_rides inner join pwtc_ride_mileage on pwtc_club_rides.ID = pwtc_ride_mileage.ride_id where pwtc_club_rides.date >= DATE_FORMAT(CURDATE(), '%Y-01-01');

/* View to list YTD rides led by all club members */
create view pwtc_ytd_rides_led_vw (title, date, member_id) as select pwtc_club_rides.title, pwtc_club_rides.date, pwtc_ride_leaders.member_id from pwtc_club_rides inner join pwtc_ride_leaders on pwtc_club_rides.ID = pwtc_ride_leaders.ride_id where pwtc_club_rides.date >= DATE_FORMAT(CURDATE(), '%Y-01-01');

/* View to list lifetime number of rides led for all club members */
create view pwtc_lifetime_num_rides_led_vw (member_id, first_name, last_name, rides_led) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_leaders.rides_led) from pwtc_membership inner join pwtc_ride_leaders on pwtc_membership.member_id = pwtc_ride_leaders.member_id group by pwtc_ride_leaders.member_id;

/* View to list year-to-date number of rides led for all club members */
create view pwtc_ytd_num_rides_led_vw (member_id, first_name, last_name, rides_led) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_leaders.rides_led) from ((pwtc_ride_leaders inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_leaders.member_id) inner join pwtc_club_rides on pwtc_ride_leaders.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.date >= DATE_FORMAT(CURDATE(), '%Y-01-01') group by pwtc_ride_leaders.member_id;

/* View to list last year's number of rides led for all club members */
create view pwtc_last_year_num_rides_led_vw (member_id, first_name, last_name, rides_led) as select pwtc_membership.member_id, pwtc_membership.first_name, pwtc_membership.last_name, SUM(pwtc_ride_leaders.rides_led) from ((pwtc_ride_leaders inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_leaders.member_id) inner join pwtc_club_rides on pwtc_ride_leaders.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.date between DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') and DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') group by pwtc_ride_leaders.member_id;
