#!/bin/sh 

cd client
#npm install
#bower install
grunt &
#echo $! > ../grunt.pid

grunt connect:assetsServer &
#echo $! > ../assets-server.pid

grunt connect:htmlServer &
#echo $! > ../html-server.pid

cd ../api
rails s -p 4000 &
#echo $! > ../api.pid
cd ../
