/* Load ride table from ride CSV file, using post_id column to hold AccessDB ride ids */
LOAD DATA INFILE '/var/lib/mysql-files/2015-Rides.csv' INTO TABLE pwtc_club_rides FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (post_id, title, @datetime, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy) SET date = CAST(@datetime AS DATE);

/* Create temporary table to hold ride mileages */
create table temp_ride_mileage (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, mileage INT UNSIGNED NOT NULL);

/* Load temporary table from ride mileage CSV file */
LOAD DATA INFILE '/var/lib/mysql-files/2015-RideSheets.csv' INTO TABLE temp_ride_mileage FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (ride_id, member_id, mileage);

/* Test for any member ids that don't exist in membership table */
select * from temp_ride_mileage where not exists(select * from pwtc_membership  where temp_ride_mileage.member_id = pwtc_membership.member_id);

/* Convert AccessDB ride ids to MySQL ride ids */
update pwtc_club_rides, temp_ride_mileage set temp_ride_mileage.ride_id = pwtc_club_rides.ID where temp_ride_mileage.ride_id = pwtc_club_rides.post_id and pwtc_club_rides.post_id is not null;

/* Insert mileages from temporary table into ride mileage table */
insert into pwtc_ride_mileage select member_id, ride_id, mileage from temp_ride_mileage where exists(select * from pwtc_membership  where temp_ride_mileage.member_id = pwtc_membership.member_id);

/* Drop  temporary table */
drop table temp_ride_mileage;

/* Set post_id column to null */
update pwtc_club_rides set post_id = null;