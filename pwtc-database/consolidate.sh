rm consolidate.txt
docker exec -i db mysql -uroot -p123 -t -v pwtc < consolidate.sql > consolidate.txt