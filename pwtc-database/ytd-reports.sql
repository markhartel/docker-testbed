/* List year-to-date mileage for all club members */
select * from pwtc_ytd_mileage_vw order by mileage desc;
select * from pwtc_ytd_mileage_vw order by last_name;

/* List year-to-date number of rides led for all club members */
select * from pwtc_ytd_num_rides_led_vw order by rides_led desc;
