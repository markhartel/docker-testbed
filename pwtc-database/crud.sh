rm crud.log
docker exec -i db mysql -uroot -p123 -t -v pwtc < crud.sql > crud.log