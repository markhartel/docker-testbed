/* List year-to-date mileage for all club members */
select * from pwtc_ytd_miles_vw order by mileage desc;
select * from pwtc_ytd_miles_vw order by last_name;

/* List year-to-date number of rides led for all club members */
select * from pwtc_ytd_led_vw order by rides_led desc;

/* List Mark's rides for this year */
select title, date, mileage from pwtc_ytd_rides_vw where member_id = '12231';

/* List rides led by Mark for this year */
select title, date from pwtc_ytd_rides_led_vw where member_id = '12231';