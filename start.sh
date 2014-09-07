#!/bin/sh 

cd client
npm install
bower install
grunt &
echo $! > ../grunt.pid

cd dist
python -m SimpleHTTPServer 2000 &
echo $! > ../../assets-server.pid

cd ../html
python -m SimpleHTTPServer 3000 &
echo $! > ../../html-server.pid

cd ../../api
rails s -p 4000 &
echo $! > ../api.pid
cd ../
