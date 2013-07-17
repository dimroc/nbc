#!/bin/bash
pid=`ps aux | ack ssh.*remote_awspostgis | ack -v perl | awk '{ print $2 }'`
kill $pid
