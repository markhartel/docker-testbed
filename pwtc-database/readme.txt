docker build -t pwtc-database .  

docker run -d --name db pwtc-database

docker logs db

docker exec -it db /bin/bash

mysql -uroot -p123
mysql> use pwtc;

docker stop db 

docker rm db

