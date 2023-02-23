#! /bin/bash
# Extract Data from a log file

echo "Extracting data"

# This script downloads the file 'web-server-access-log.txt.gz'
# from "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/".
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz" 

# The script then extracts the .txt file using gunzip.
gunzip -f web-server-access-log.txt.gz
# sudo tar -xvf file.tar   

# The .txt file contains the timestamp, latitude, longitude 
# and visitor id apart from other data.
cut -d"#" -f1-4 web-server-access-log.txt > extracted-data.txt


echo "Transforming data"
# Transforms the text delimeter from "#" to "," and saves to a csv file.
tr "#" "," < extracted-data.txt  > extracted-data.csv 

echo "Loading data"
# Loads the data from the CSV file into the table 'access_log' in PostgreSQL database.
echo "\c template1;  \COPY access_log FROM '/home/project/postgres/extracted-data.csv' DELIMITERS ',' csv header;"  | psql --username=postgres --host=localhost

# show elements saved into database 
echo '\c template1; \\SELECT * from access_log;' | psql --username=postgres --host=localhost
