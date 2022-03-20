#!/bin/bash

if [ "$1" = "" ]; then
  read -p "Project directory: " Response
  if [ "$Response" = "" ]; then
    exit
  fi
  HOMEDIR=$Response
else
  HOMEDIR=$1
fi

if [ -e ~$HOMEDIR ]; then
  echo "Directory $HOMEDIR already exists"
  exit
fi

mkdir -p $HOMEDIR
cd $HOMEDIR

ddev config --project-type=drupal9 --docroot=web --create-docroot

sed -i '' "s/router_http_port: \"80\"/router_http_port: \"8080\"/g" .ddev/config.yaml
sed -i '' "s/router_https_port: \"443\"/router_https_port: \"8043\"/g" .ddev/config.yaml
sed -i '' "s/mutagen_enabled: false/mutagen_enabled: true/g" .ddev/config.yaml

ddev start
ddev composer create "drupal/recommended-project" --no-install
ddev composer require drush/drush --no-install
ddev composer install
ddev drush site:install -y
ddev composer require 'drupal/admin_toolbar:^3.1'
ddev composer require 'drupal/devel:^4.1'
ddev drush cr
ddev drush en admin_toolbar,admin_toolbar_tools,devel
ddev drush uli
ddev launch
