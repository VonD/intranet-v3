#!/bin/sh 

[ -e grunt.pid ] && cat grunt.pid | xargs kill
[ -e grunt.pid ] && rm grunt.pid

[ -e html-server.pid ] && cat html-server.pid | xargs kill
[ -e html-server.pid ] && rm html-server.pid

[ -e assets-server.pid ] && cat assets-server.pid | xargs kill
[ -e assets-server.pid ] && rm assets-server.pid

[ -e api.pid ] && cat api.pid | xargs kill
[ -e api.pid ] && rm api.pid
