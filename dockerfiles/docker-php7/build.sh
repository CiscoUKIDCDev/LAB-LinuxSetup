#!/bin/bash

YESTERDAY=`date -d "1 day ago" +%y%m%d`

docker build -t zend/php:7.0-$YESTERDAY .


