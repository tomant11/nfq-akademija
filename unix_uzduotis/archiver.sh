#!/bin/bash

data=$(date +"%Y-%m-%d")
val=$(date +"%H")
min=$(date +"%M")

BASEDIR=$(dirname $0)
WORKDIR=$BASEDIR/log/${data}
LOGFILE=/var/log/apache2/access.log

if [ ! -d $BASEDIR/log ]
 then 
  mkdir $BASEDIR/log
fi

if [ ! -d $WORKDIR ]
 then 
  mkdir $WORKDIR
fi

cat $LOGFILE | grep "POST" > /tmp/_posts.txt
tar cfP $WORKDIR/log_${val}h_${min}min.log.tar.gz /tmp/_posts.txt
rm -rf /tmp/_posts.txt