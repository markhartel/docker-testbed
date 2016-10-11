
select pwtc_club_rides.title, pwtc_club_rides.date, pwtc_ride_mileage.mileage from pwtc_club_rides inner join pwtc_ride_mileage on pwtc_club_rides.ID = pwtc_ride_mileage.ride_id where pwtc_ride_mileage.member_id = '12231' and pwtc_club_rides.date >= '2015-01-01' order by pwtc_club_rides.date;

