start transaction;

SET @MAXLABEL = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 YEAR), 'Totals Through %Y');
SET @MAXDATE = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 YEAR), '%Y-12-31');

select COUNT(*) from pwtc_club_rides where date <= @MAXDATE;

insert into pwtc_club_rides (title, date) values (@MAXLABEL, @MAXDATE);

select @LASTID:=MAX(ID) from pwtc_club_rides;

insert into pwtc_ride_mileage (member_id, ride_id, mileage) select pwtc_membership.member_id, @LASTID, SUM(pwtc_ride_mileage.mileage) from ((pwtc_ride_mileage inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_mileage.member_id) inner join pwtc_club_rides on pwtc_ride_mileage.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.ID <> @LASTID and pwtc_club_rides.date <= @MAXDATE group by pwtc_ride_mileage.member_id;

insert into pwtc_ride_leaders (member_id, ride_id, rides_led) select pwtc_membership.member_id, @LASTID, SUM(pwtc_ride_leaders.rides_led) from ((pwtc_ride_leaders inner join pwtc_membership on pwtc_membership.member_id = pwtc_ride_leaders.member_id) inner join pwtc_club_rides on pwtc_ride_leaders.ride_id = pwtc_club_rides.ID) where pwtc_club_rides.ID <> @LASTID and pwtc_club_rides.date <= @MAXDATE group by pwtc_ride_leaders.member_id;

delete from pwtc_ride_mileage where ride_id in (select ID from pwtc_club_rides where ID <> @LASTID and date <= @MAXDATE);

delete from pwtc_ride_leaders where ride_id in (select ID from pwtc_club_rides where ID <> @LASTID and date <= @MAXDATE);

delete from pwtc_club_rides where ID <> @LASTID and date <= @MAXDATE;

select COUNT(*) from pwtc_club_rides where date <= @MAXDATE;

commit;
/* rollback; */