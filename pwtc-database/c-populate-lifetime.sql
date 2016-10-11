/* Create dummy ride to hold member lifetime totals */
insert into pwtc_club_rides (title, date) values ('Totals Through 2014', '2014-12-31');

/* Create temporary table to hold lifetime mileages */
create table temp_life_mileage (member_id VARCHAR(5) NOT NULL, mileage INT UNSIGNED NOT NULL);

/* Load temporary table from lifetime mileage CSV file */
LOAD DATA INFILE '/var/lib/mysql-files/2015-LifeMiles.csv' INTO TABLE temp_life_mileage FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (member_id, @dummy, @dummy, mileage);

/* DB CHECK: Test for any member ids that don't exist in membership table */
select * from temp_life_mileage where not exists(select * from pwtc_membership  where temp_life_mileage.member_id = pwtc_membership.member_id);

/* Insert lifetime mileage from temporary table into ride mileage table */
insert into pwtc_ride_mileage select member_id, 1, mileage from temp_life_mileage where exists(select * from pwtc_membership  where temp_life_mileage.member_id = pwtc_membership.member_id);

/* Drop  temporary table */
/*
drop table temp_life_mileage;
*/