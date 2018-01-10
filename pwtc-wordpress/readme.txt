docker-compose up -d
docker-compose down

docker cp ./2017-Members.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2017-LifeMiles.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2017-Rides.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2017-RideSheets.csv pwtcwordpress_db_1:/var/lib/mysql-files

docker exec -it pwtcwordpress_db_1 /bin/bash
docker exec -it pwtcwordpress_wp_1 /bin/bash

mysql -uroot -pwordpress

192.168.99.100:8000

Post Type for the Ride Object: scheduled_rides
Metakey for the Ride Start Date: start_time

use civicrm;
select table_name, table_type from information_schema.tables where table_schema = 'civicrm';
select column_name, data_type, ordinal_position from information_schema.columns where table_schema = 'civicrm' and table_name = 'civicrm_contact';
select id, contact_type, first_name, last_name from civicrm_contact where last_name = 'Adams';




