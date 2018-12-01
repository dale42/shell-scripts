#!/bin/bash
#
# Backup up a website database and files.
#
VERSION=1.0

if [ "$1" = "" ] ; then
  echo ""
  echo "website-backup.sh V$VERSION"
  echo ""
  echo "Backup a Drupal or WordPress website database and files."
  echo " - Attempts to autodetect Drupal or WordPress site"
  echo " - Attempts to autodetect the database credentials"
  echo " - Backup types:"
  echo "     full: file and database, extention is .tgz"
  echo "       db: sql dump file, extension is .sql.gz"
  echo "     file: web root file backup, extension is .tgz"
  echo " - If no backup-filename is given, defaults to ~/backups/files-yyyy-mm-dd.tgz,"
  echo "   ~/backups/full-yyyy-mm-dd.tgz, or ~/backups/db-yyyy-mm-dd.sql.gz"
  echo ""
  echo "Usage:"
  echo ""
  echo "   website-backup.sh website-directory [ backup-type ] [ output-name-root ] [ output-directory ]"
  echo "   website-backup.sh public_html"
  echo ""
  exit 0
fi

#
# Input parameter validation
#

# Verify website directory
if [ ! -d "$1" ]; then
  echo " ERROR: $1 is not a directory"
  exit 1
fi
websiteDirectory=$1
parentDirectory=$(dirname $1)
rootDirectory=$(basename $1)

# If optional parameter backup type is present, verify it's a valid choice, or default it to full.
if [ "$2" == "" ] || [ "$2" == "db" ]; then
  backupType="db"
elif [ "$2" == "full" ] || [ "$2" == "file" ] ; then
  backupType=$2
else
  echo " ERROR: Invalid backup type: $2"
  echo "        Please use full, db, or file"
  exit 1
fi

# Default the name root if it is not present
if [ "$3" == "" ]; then
  fileNameRoot="backup"
else
  fileNameRoot=$3
fi

# If an output directory is given, verify it exists. If it doesn't exist, use ~/backups,
# if that doesn't exist, use the current working directory
if [ "$4" == "" ]; then
  outputDir="$(pwd)"
else
  if [ -d $4 ]; then
    outputDir=$4
  else
    echo " ERROR: $4 is not a directory"
    exit 1
  fi
fi

dateStamp="$(date '+%Y-%m-%d')"

outputFilenameSql="$fileNameRoot-db-$dateStamp.sql.gz"
outputFilenameTar="$fileNameRoot-$backupType-$dateStamp.tgz"

#
# Website discovery
#
if [ -f $websiteDirectory/wp-config.php ]; then
  # WordPress site
  USERNAME=`grep 'DB_USER' $websiteDirectory/wp-config.php | awk -F "'" '{ print $4 }'`
  PASSWORD=`grep 'DB_PASSWORD' $websiteDirectory/wp-config.php | awk -F "'" '{ print $4 }'`
  DATABASE=`grep 'DB_NAME' $websiteDirectory/wp-config.php | awk -F "'" '{ print $4 }'`
  HOST=`grep 'DB_HOST' $websiteDirectory/wp-config.php | awk -F "'" '{ print $4 }'`
elif [ -f $websiteDirectory/sites/default/settings.php ]; then
  # Drupal site
  # This detection method can break in any number of ways. It will need to be bolstered.
  USERNAME=`grep "^[[:space:]]*'username'" $websiteDirectory/sites/default/settings.php | awk -F "'" '{ print $4 }'`
  PASSWORD=`grep "^[[:space:]]*'password'" $websiteDirectory/sites/default/settings.php | awk -F "'" '{ print $4 }'`
  DATABASE=`grep "^[[:space:]]*'database'" $websiteDirectory/sites/default/settings.php | awk -F "'" '{ print $4 }'`
  HOST=`grep "^[[:space:]]*'host'" $websiteDirectory/sites/default/settings.php | awk -F "'" '{ print $4 }'`
else
  echo " WARNING: Can not determine the CMS"
  exit 1
fi

#
# Perform the backup
#
echo ""
echo "Performing $backupType backup of $websiteDirectory to $outputDir"
echo ""
if [ "$backupType" == "db" ]; then
  mysqldump -u$USERNAME -p$PASSWORD -h$HOST $DATABASE | gzip > $outputDir/$outputFilenameSql
elif [ "$backupType" == "file" ]; then
  cd $parentDirectory
  tar -czf $outputDir/$outputFilenameTar $rootDirectory
elif [ "$backupType" == "full" ]; then
  cd $parentDirectory
  mysqldump -u$USERNAME -p$PASSWORD -h$HOST $DATABASE | gzip > $outputFilenameSql
  tar -czf $outputDir/$outputFilenameTar $rootDirectory $outputFilenameSql
  rm $outputFilenameSql
fi

exit 0
