start transaction;

set @MEMBERID='XXXXX';

insert into pwtc_membership (member_id, last_name, first_name, expir_date) values (@MEMBERID, 'Doe', 'John', curdate()) on duplicate key update expir_date = curdate();

select * from pwtc_membership where member_id = @MEMBERID;

insert into pwtc_membership (member_id, last_name, first_name, expir_date) values (@MEMBERID, 'Doe', 'John', '2019-01-01') on duplicate key update expir_date = '2019-01-01';

select * from pwtc_membership where member_id = @MEMBERID;

insert into pwtc_club_rides (title, date) values ('New Ride', curdate());

select @RIDEID:=MAX(ID) from pwtc_club_rides;

select * from pwtc_club_rides where ID = @RIDEID;

select * from pwtc_lifetime_mileage_vw where member_id = @MEMBERID;

insert into pwtc_ride_mileage (member_id, ride_id, mileage) values (@MEMBERID, @RIDEID, 98) on duplicate key update mileage = 98;

select * from pwtc_lifetime_mileage_vw where member_id = @MEMBERID;

insert into pwtc_ride_mileage (member_id, ride_id, mileage) values (@MEMBERID, @RIDEID, 99) on duplicate key update mileage = 99;

select * from pwtc_lifetime_mileage_vw where member_id = @MEMBERID;

delete from pwtc_ride_mileage where member_id = @MEMBERID or ride_id = @RIDEID;

select * from pwtc_lifetime_mileage_vw where member_id = @MEMBERID;

delete from pwtc_club_rides where ID = @RIDEID;

select * from pwtc_club_rides where ID = @RIDEID;

delete from pwtc_membership where member_id = @MEMBERID;

select * from pwtc_membership where member_id = @MEMBERID;

commit;
/* rollback; */