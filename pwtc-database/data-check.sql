select a.last_name, a.first_name, a.member_id, b.member_id, a.expir_date, b.expir_date from pwtc_membership a, pwtc_membership b where a.last_name = b.last_name and a.first_name = b.first_name and a.member_id <> b.member_id order by a.last_name;

select * from pwtc_membership where not exists (select * from pwtc_ride_mileage where pwtc_membership.member_id = pwtc_ride_mileage.member_id) order by last_name;
