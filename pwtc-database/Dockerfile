FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD 123  
ENV MYSQL_DATABASE pwtc  
ENV MYSQL_USER pwtc
ENV MYSQL_PASSWORD 123

ADD a-create-tables.sql /docker-entrypoint-initdb.d
ADD b-populate-riders.sql /docker-entrypoint-initdb.d
ADD c-populate-lifetime.sql /docker-entrypoint-initdb.d
ADD d-populate-2015.sql /docker-entrypoint-initdb.d
ADD e-populate-2016.sql /docker-entrypoint-initdb.d
ADD 2015-Members.csv /var/lib/mysql-files
ADD 2015-Rides.csv /var/lib/mysql-files
ADD 2015-RideSheets.csv /var/lib/mysql-files
ADD 2015-LifeMiles.csv /var/lib/mysql-files
ADD 2016-Members.csv /var/lib/mysql-files
ADD 2016-Rides.csv /var/lib/mysql-files
ADD 2016-RideSheets.csv /var/lib/mysql-files
ADD 2016-LifeMiles.csv /var/lib/mysql-files
