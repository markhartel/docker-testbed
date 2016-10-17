rm lifetime-reports.log
docker exec -i db mysql -uroot -p123 -t -v pwtc < lifetime-reports.sql > lifetime-reports.log

rm ytd-reports.log
docker exec -i db mysql -uroot -p123 -t -v pwtc < ytd-reports.sql > ytd-reports.log

rm lastyear-reports.log
docker exec -i db mysql -uroot -p123 -t -v pwtc < lastyear-reports.sql > lastyear-reports.log
