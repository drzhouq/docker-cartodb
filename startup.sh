#!/bin/bash

PORT=3000

service postgresql start
rc=1
while [ $rc != 0 ]
do
sleep 10 
psql -U postgres geocoder -c "select count(*) from cdb_conf;"  
rc=$?
done 
service redis-server start
service nginx start
service varnish start
cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

cd /cartodb
source /usr/local/rvm/scripts/rvm
bundle exec script/restore_redis
bundle exec script/resque > resque.log 2>&1 &
bundle exec rails s -p $PORT

