docker-compose up -d
docker-compose down

docker cp ./2016-Members.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2015-LifeMiles.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2015-Rides.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2015-RideSheets.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2016-Rides.csv pwtcwordpress_db_1:/var/lib/mysql-files
docker cp ./2016-RideSheets.csv pwtcwordpress_db_1:/var/lib/mysql-files

docker exec -it pwtcwordpress_db_1 /bin/bash

mysql -uroot -pwordpress

192.168.99.100:8000

Post Type for the Ride Object: scheduled_rides
Metakey for the Ride Start Date: start_time

