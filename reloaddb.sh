#!/bin/bash
#
# Remove pre-existing tables and load a sql file into the database.
#

if [ "$1" = "" ] ; then
  echo "Usage: loaddb username password database sql-file"
  exit
fi

if [ ! -f $4 ] ; then
  echo "$4 is not a file"
  exit
fi

echo "=> Removing database tables in $3"
mysql --user=$1 --password=$2 -BNe "show tables" $3 | tr '\n' ',' | sed -e 's/,$//' | awk '{print "SET FOREIGN_KEY_CHECKS = 0;DROP TABLE IF EXISTS " $1 ";SET FOREIGN_KEY_CHECKS = 1;"}' | mysql --user=$1 --password=$2 $3
echo "   Complete"

echo "=> Loading files from $4"
mysql --user=$1 --password=$2 $3 < $4
echo "   Complete"
