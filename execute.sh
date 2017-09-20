#!/bin/sh
rm -rf $1;
mkdir $1;
pybot -v CONFIG:config.py --loglevel trace --output $1/output.xml --report $1/report.html --log $1/log.html $1.robot
