#!/bin/bash
#
# Remove pre-existing tables and load a sql file into the database.
#
VERSION=1.1

if [ "$1" = "" ] ; then
  echo ""
  echo "restore-db.sh V$VERSION"
  echo ""
  echo "Restore a sql file, or gzipped sql file, to the specified database."
  echo ""
  echo "Usage:"
  echo "   restore-db.sh username password database sql-file.sql"
  echo "   restore-db.sh username password database sql-file.sql.gz"
  echo ""
  exit 0
fi

if [ ! -f $4 ] ; then
  echo "$4 is not a file"
  exit
fi

fileType=${4##*.}
if [ "$fileType" = "sql" ] ; then
  isCompressed=false
elif [ "$fileType" = "gz" ] ; then
  isCompressed=true
else
  echo " WARNING: Do no understand the filetype: $fileType"
  exit 1
fi

echo "=> Removing database tables in $3"
mysql --user=$1 --password=$2 -BNe "show tables" $3 | tr '\n' ',' | sed -e 's/,$//' | awk '{print "SET FOREIGN_KEY_CHECKS = 0;DROP TABLE IF EXISTS " $1 ";SET FOREIGN_KEY_CHECKS = 1;"}' | mysql --user=$1 --password=$2 $3
echo "   Complete"

echo "=> Loading files from $4"
if [ "$isCompressed" = "true" ] ; then
  gunzip -c $4 | mysql --user=$1 --password=$2 $3
else
  mysql --user=$1 --password=$2 $3 < $4
fi
echo "   Complete"
exit 0
