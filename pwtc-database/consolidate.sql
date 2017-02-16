start transaction;

SET @MAXLABEL = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 YEAR), 'Totals Through %Y');
SET @MAXDATE = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 YEAR), '%Y-12-31');

select COUNT(*) from pwtc_club_rides where date <= @MAXDATE;

insert into pwtc_club_rides (title, date) values (@MAXLABEL, @MAXDATE);

select @LASTID:=MAX(ID) from pwtc_club_rides;

insert into pwtc_ride_mileage (member_id, ride_id, mileage) select c.member_id, @LASTID, SUM(m.mileage) from ((pwtc_ride_mileage as m inner join pwtc_membership as c on c.member_id = m.member_id) inner join pwtc_club_rides as r on m.ride_id = r.ID) where r.ID <> @LASTID and r.date <= @MAXDATE group by m.member_id;

insert into pwtc_ride_leaders (member_id, ride_id, rides_led) select c.member_id, @LASTID, SUM(l.rides_led) from ((pwtc_ride_leaders as l inner join pwtc_membership as c on c.member_id = l.member_id) inner join pwtc_club_rides as r on l.ride_id = r.ID) where r.ID <> @LASTID and r.date <= @MAXDATE group by l.member_id;

delete from pwtc_ride_mileage where ride_id in (select ID from pwtc_club_rides where ID <> @LASTID and date <= @MAXDATE);

delete from pwtc_ride_leaders where ride_id in (select ID from pwtc_club_rides where ID <> @LASTID and date <= @MAXDATE);

delete from pwtc_club_rides where ID <> @LASTID and date <= @MAXDATE;

select COUNT(*) from pwtc_club_rides where date <= @MAXDATE;

commit;
/* rollback; */