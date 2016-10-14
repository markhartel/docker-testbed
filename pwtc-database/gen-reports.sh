rm lifetime-reports.txt
docker exec -i db mysql -uroot -p123 -t -v pwtc < lifetime-reports.sql > lifetime-reports.txt

rm ytd-reports.txt
docker exec -i db mysql -uroot -p123 -t -v pwtc < ytd-reports.sql > ytd-reports.txt

rm lastyear-reports.txt
docker exec -i db mysql -uroot -p123 -t -v pwtc < lastyear-reports.sql > lastyear-reports.txt
