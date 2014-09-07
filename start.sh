#!/bin/sh 

cd client
npm install
bower install
grunt &
echo $! > ../grunt.pid

cd dist
http-server -p 2000 --cors &
echo $! > ../../assets-server.pid

cd ../bower_components
http-server -p 2001 --cors &
echo $! > ../../components-server.pid

cd ../html
http-server -p 3000 --cors &
echo $! > ../../html-server.pid

cd ../../api
rails s -p 4000 &
echo $! > ../api.pid
cd ../
