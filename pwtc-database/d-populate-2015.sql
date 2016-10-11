/* Load ride table from ride CSV file, using post_id column to hold AccessDB ride ids */
LOAD DATA INFILE '/var/lib/mysql-files/2015-Rides.csv' INTO TABLE pwtc_club_rides FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (post_id, title, @datetime, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy) SET date = CAST(@datetime AS DATE);

/* Create temporary table to hold ride mileages */
create table temp_ride_mileage (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, mileage INT UNSIGNED NOT NULL);

/* Load temporary table from ride mileage CSV file */
LOAD DATA INFILE '/var/lib/mysql-files/2015-RideSheets.csv' INTO TABLE temp_ride_mileage FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (ride_id, member_id, mileage);

/* DB CHECK: Test for any member ids that don't exist in membership table */
select * from temp_ride_mileage where not exists(select * from pwtc_membership  where temp_ride_mileage.member_id = pwtc_membership.member_id);

/* Convert AccessDB ride ids to MySQL ride ids */
update pwtc_club_rides, temp_ride_mileage set temp_ride_mileage.ride_id = pwtc_club_rides.ID where temp_ride_mileage.ride_id = pwtc_club_rides.post_id and pwtc_club_rides.post_id is not null;

/* Insert mileages from temporary table into ride mileage table */
insert into pwtc_ride_mileage select member_id, ride_id, mileage from temp_ride_mileage where exists(select * from pwtc_membership  where temp_ride_mileage.member_id = pwtc_membership.member_id);

/* Create temporary table to hold club membership */
create table temp_membership (member_id VARCHAR(5) NOT NULL, full_name TEXT NOT NULL);

/* Load temporary table from club membership CSV file */
LOAD DATA INFILE '/var/lib/mysql-files/2016-Members.csv' INTO TABLE temp_membership FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (member_id, @lastname, @firstname, @dummy, @dummy) SET full_name = CONCAT(@lastname, ', ', @firstname);

/* Create temporary table for duplicate full names */
create table temp_dup_names (full_name TEXT NOT NULL);

/* Populate temporary table with duplicate full names from temporary membership table */
insert into temp_dup_names select distinct a.full_name from temp_membership a, temp_membership b where a.full_name = b.full_name and a.member_id <> b.member_id order by a.full_name;

/* Create temporary table to hold club rides and their leaders */
create table temp_club_rides (ride_id BIGINT UNSIGNED NOT NULL, leader1 TEXT, leader2 TEXT, leader3 TEXT, leader4 TEXT);

/* Load temporary table from ride CSV file */
LOAD DATA INFILE '/var/lib/mysql-files/2015-Rides.csv' INTO TABLE temp_club_rides FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (ride_id, @dummy, @dummy, leader1, leader2, leader3, leader4, @dummy, @dummy);

/* Create temporary table to hold ride leaders */
create table temp_ride_leaders (member_id VARCHAR(5) NOT NULL, ride_id BIGINT UNSIGNED NOT NULL, rides_led INT UNSIGNED NOT NULL);

/* DB CHECK: Test temporary ride table for rides with 1st leaders that are not in the temporary membership table */
select ride_id, leader1 from temp_club_rides where not exists(select * from temp_membership  where temp_club_rides.leader1 = temp_membership.full_name) and temp_club_rides.leader1 <> '';

/* DB CHECK: Test temporary ride table for rides with 1st leaders that have full names that are duplicates */
select ride_id, leader1 from temp_club_rides where exists(select * from temp_dup_names where temp_club_rides.leader1 = temp_dup_names.full_name);

/* Insert 1st leaders from temporary ride table into temporary ride leader table */
insert into temp_ride_leaders select temp_membership.member_id, temp_club_rides.ride_id, 1 from temp_membership inner join temp_club_rides on temp_membership.full_name = temp_club_rides.leader1 and temp_club_rides.leader1 <> '';

/* DB CHECK: Test temporary ride table for rides with 2nd leaders that are not in the temporary membership table */
select ride_id, leader2 from temp_club_rides where not exists(select * from temp_membership  where temp_club_rides.leader2 = temp_membership.full_name) and temp_club_rides.leader2 <> '';

/* DB CHECK: Test temporary ride table for rides with 2nd leaders that have full names that are duplicates */
select ride_id, leader2 from temp_club_rides where exists(select * from temp_dup_names where temp_club_rides.leader2 = temp_dup_names.full_name);

/* Insert 2nd leaders from temporary ride table into temporary ride leader table */
insert into temp_ride_leaders select temp_membership.member_id, temp_club_rides.ride_id, 1 from temp_membership inner join temp_club_rides on temp_membership.full_name = temp_club_rides.leader2 and temp_club_rides.leader2 <> '';

/* DB CHECK: Test temporary ride table for rides with 3rd leaders that are not in the temporary membership table */
select ride_id, leader3 from temp_club_rides where not exists(select * from temp_membership  where temp_club_rides.leader3 = temp_membership.full_name) and temp_club_rides.leader3 <> '';

/* DB CHECK: Test temporary ride table for rides with 3rd leaders that have full names that are duplicates */
select ride_id, leader3 from temp_club_rides where exists(select * from temp_dup_names where temp_club_rides.leader3 = temp_dup_names.full_name);

/* Insert 3rd leaders from temporary ride table into temporary ride leader table */
insert into temp_ride_leaders select temp_membership.member_id, temp_club_rides.ride_id, 1 from temp_membership inner join temp_club_rides on temp_membership.full_name = temp_club_rides.leader3 and temp_club_rides.leader3 <> '';

/* DB CHECK: Test temporary ride table for rides with 4th leaders that are not in the temporary membership table */
select ride_id, leader4 from temp_club_rides where not exists(select * from temp_membership  where temp_club_rides.leader4 = temp_membership.full_name) and temp_club_rides.leader4 <> '';

/* DB CHECK: Test temporary ride table for rides with 4th leaders that have full names that are duplicates */
select ride_id, leader4 from temp_club_rides where exists(select * from temp_dup_names where temp_club_rides.leader4 = temp_dup_names.full_name);

/* Insert 4th leaders from temporary ride table into temporary ride leader table */
insert into temp_ride_leaders select temp_membership.member_id, temp_club_rides.ride_id, 1 from temp_membership inner join temp_club_rides on temp_membership.full_name = temp_club_rides.leader4 and temp_club_rides.leader4 <> '';

/* DB CHECK: Test for any member ids that don't exist in membership table */
select * from temp_ride_leaders where not exists(select * from pwtc_membership  where temp_ride_leaders.member_id = pwtc_membership.member_id);

/* Convert AccessDB ride ids to MySQL ride ids */
update pwtc_club_rides, temp_ride_leaders set temp_ride_leaders.ride_id = pwtc_club_rides.ID where temp_ride_leaders.ride_id = pwtc_club_rides.post_id and pwtc_club_rides.post_id is not null;

/* Insert leaders from temporary table into ride leaders table */
insert into pwtc_ride_leaders select member_id, ride_id, rides_led from temp_ride_leaders where exists(select * from pwtc_membership  where temp_ride_leaders.member_id = pwtc_membership.member_id);

/* Drop  temporary tables */
drop table temp_ride_mileage;
drop table temp_dup_names;
drop table temp_membership;
drop table temp_club_rides;
drop table temp_ride_leaders;

/* Set post_id column to null */
update pwtc_club_rides set post_id = null;