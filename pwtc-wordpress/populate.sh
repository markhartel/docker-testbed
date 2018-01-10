rm populate-riders.log
docker exec -i pwtcwordpress_db_1 mysql -uroot -pwordpress -t -v wordpress < populate-riders.sql > populate-riders.log

rm populate-lifetime.log
docker exec -i pwtcwordpress_db_1 mysql -uroot -pwordpress -t -v wordpress < populate-lifetime.sql > populate-lifetime.log

rm populate-2017.log
docker exec -i pwtcwordpress_db_1 mysql -uroot -pwordpress -t -v wordpress < populate-2017.sql > populate-2017.log
