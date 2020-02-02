#!/bin/bash
#
# Backup up a website database and files.
#
Version=1.0

#
# Banner
#
echo ""
echo "Make a WordPress Site V$Version"

# TODO: verify wp-cli and mysql are installed

echo ""
echo "A WordPress site and database will be created in your local LAMP environment."
echo ""
read -p "Do you wish to continue? (y/n): " Response
if [[ ! $Response =~ ^[yY]$ ]]
then
  exit
fi

# Source the .make-wp-site.sh file if it exists
if [ -r ~/.make-wp-site.sh ]
then
  source ~/.make-wp-site.sh
else
  echo "Note: You can provide default values in a ~/.make-wp-site.sh file"
fi

echo ""
echo "The project name was be used to provide default values for database, directory"
echo "and account names. It should contain only alphanumeric characters and hyphens."
echo "Examples:"
echo " nightwing -> db user: nightwing, db name: nightwing, WordPress directory: ~/Sites/nightwing"
echo ""
read -p "Project name: " Project_Name

#
# Generate Default Values
#
Default_DB_User=$Project_Name
Default_DB_Password=$(base64 /dev/urandom | head -c 16)
Default_DB_Name=$Project_Name
if [[ -z $Default_Admin_Name ]]
then
  Default_Admin_Name=$Project_Name
fi
Default_Admin_Pass=$(base64 /dev/urandom | head -c 16)
Default_Site_URL=http://$Project_Name.l
if [[ -z $Apache_Site_Directory ]]
then
  Default_Site_Directory=$Apache_Site_Directory/$Project_Name
fi

#
# Get the database details
#
read -p "Database user ($Default_DB_User): " DB_User
if [[ -z $DB_User ]]
then
  DB_User=$Default_DB_User
fi

read -p "Database password ($Default_DB_Password): " DB_Password
if [[ -z $DB_Password ]]
then
  DB_Password=$Default_DB_Password
fi

read -p "Database name ($Default_DB_Name): " DB_Name
if [[ -z $DB_Name ]]
then
  DB_Name=$Default_DB_Name
fi

if [[ -z $Default_MySql_Account ]]
then
  read -p "System MySql Account Name: " MySql_Account
else
  MySql_Account=$Default_MySql_Account
fi

if [[ -z $Default_MySql_Password ]]
then
  read -p "System MySql Account Name: " MySql_Password
else
  MySql_Password=$Default_MySql_Password
fi

#
# Make sure the database doesn't already exist
#
results=$(mysql -u${MySql_Account} -p${MySql_Password} -s -N -e "SELECT schema_name FROM information_schema.schemata WHERE schema_name = '${DB_Name}'" information_schema)
echo "${results}"
if [[ -n "${results}" ]]; then
  echo ""
  echo "ERROR: A database named $DB_Name already exists."
  echo ""
  exit
fi

read -p "Site URL ($Default_Site_URL): " Site_URL
if [[ -z $Site_URL ]]
then
  Site_URL=$Default_Site_URL
fi

read -p "WordPress admin name ($Default_Admin_Name): " Admin_Name
if [[ -z $Admin_Name ]]
then
  Admin_Name=$Default_Admin_Name
fi

read -p "WordPress admin password ($Default_Admin_Pass): " Admin_Password
if [[ -z $Admin_Password ]]
then
  Admin_Password=$Default_Admin_Pass
fi

read -p "WordPress admin email ($Default_Admin_Email): " Admin_Email
if [[ -z $Admin_Email ]]
then
  Admin_Email=$Default_Admin_Email
fi

read -p "WordPress site directory ($Default_Site_Directory)" Site_Directory
if [[ -z $Site_Directory ]]
then
  Site_Directory=$Default_Site_Directory
fi
if [[ -d $Site_Directory ]]
then
  echo ""
  echo "ERROR: $Site_Directory already exists."
  echo ""
  exit
fi

# Verify input
echo ""
echo "The following input will be used to create the WordPress site:"
echo ""
echo "Database:"
echo "       User     : $DB_User"
echo "       Password : $DB_Password"
echo "       Name     : $DB_Name"
echo ""
echo "WordPress:"
echo " Site URL       : $Site_URL"
echo " Admin User     : $Admin_Name"
echo " Admin Password : $Admin_Password"
echo " Admin Email    : $Admin_Email"
echo " Site Directory : $Site_Directory"
echo ""

read -p "Do you wish to create the site? (y/n): " Continue

if [[ ! $Continue =~ ^[yY]$ ]]
then
  exit
fi

#
# Create the database
#
SQLCreate="CREATE DATABASE IF NOT EXISTS $DB_Name;"
SQLGrant="GRANT ALL ON $DB_Name.* TO '$DB_User'@'localhost' IDENTIFIED BY '$DB_Password';"
SQLFlush="FLUSH PRIVILEGES;"
SQL_Commands="${SQLCreate} ${SQLGrant} ${SQLFlush}"
mysql -u$MySql_Account -p$MySql_Password -e "$SQL_Commands"

#
# Install WordPress
#
mkdir $Site_Directory
cd $Site_Directory
wp core download
wp core config \
  --dbuser=$DB_User \
  --dbpass=$DB_Password \
  --dbname=$DB_Name

wp core install \
  --url=$Site_URL \
  --title="$Project_Name Site" \
  --admin_name=$Admin_Name \
  --admin_password=$Admin_Password \
  --admin_email=$Admin_Email

wp plugin uninstall \
  hello \
  --deactivate

wp plugin install \
  advanced-custom-fields \
  better-wp-security \
  classic-editor \
  custom-post-type-ui \
  redirection \
  svg-support \
  --activate

# Configure General options
wp option update permalink_structure "/%postname%/"
wp option update timezone_string "America/Vancouver"

# Configure classic editor plugin
wp option update classic-editor-replace classic
wp option update classic-editor-allow-users allow

wp cache flush
