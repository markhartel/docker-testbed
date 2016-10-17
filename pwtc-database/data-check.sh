rm data-check.log
docker exec -i db mysql -uroot -p123 -t -v pwtc < data-check.sql > data-check.log