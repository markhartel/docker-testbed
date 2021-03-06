/* Load membership table from membership CSV file */
LOAD DATA INFILE '/var/lib/mysql-files/2017-Members.csv' INTO TABLE wp_pwtc_membership FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' (member_id, last_name, first_name, @datetime, @dummy) SET expir_date = CAST(@datetime AS DATE);
