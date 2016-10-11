/* List last year's mileage (500 miles or more) for all club members */
select * from pwtc_last_year_mileage_vw where mileage >= 500 order by mileage desc;

/* List last year's lifetime mileage achievement milestones for all club members */ 
select * from pwtc_last_year_lifetime_achievement_vw order by mileage desc;

select * from pwtc_last_year_num_rides_led_vw order by rides_led desc;
select * from pwtc_last_year_num_rides_led_vw order by last_name;

/* List last year's number of rides led (more than 12) for all club members */
select * from pwtc_last_year_num_rides_led_vw where rides_led > 12 order by rides_led desc;