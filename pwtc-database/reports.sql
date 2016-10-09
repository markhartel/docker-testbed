/* List lifetime mileage for all club members */
select * from pwtc_lifetime_mileage_vw order by mileage desc;
select * from pwtc_lifetime_mileage_vw order by last_name;

/* List year-to-date mileage for all club members */
select * from pwtc_ytd_mileage_vw order by mileage desc;
select * from pwtc_ytd_mileage_vw order by last_name;

/* List last year's mileage (500 miles or more) for all club members */
select * from pwtc_last_year_mileage_vw where mileage >= 500 order by mileage desc;

/* List last year's lifetime mileage achievement milestones for all club members */ 
select * from pwtc_last_year_lifetime_achievement_vw order by mileage desc;

/* List year-to-date number of rides led for all club members */
select * from pwtc_ytd_num_rides_led_vw order by rides_led desc;

/* List last year's number of rides led (more than 12) for all club members */
select * from pwtc_last_year_num_rides_led_vw where rides_led > 12 order by rides_led desc;


select pwtc_club_rides.title, pwtc_club_rides.date, pwtc_ride_mileage.mileage from pwtc_club_rides inner join pwtc_ride_mileage on pwtc_club_rides.ID = pwtc_ride_mileage.ride_id where pwtc_ride_mileage.member_id = '12231' and pwtc_club_rides.date >= '2015-01-01' order by pwtc_club_rides.date;

