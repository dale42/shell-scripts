# dev-shell-scripts

A collection of shells scripts for doing routine stuff on the command line.

## Overview

| Script | Description |
| --- | --- |
| dropalltables | Drop all tables in a database |
| restore-db.sh | Restore a sql dump file, compresses or uncompressed, to a database | 
| website-backup.sh | Database and file backup of a Drupal or WordPress website |

## website-backup.sh

A general purpose script for taking a database, file, or database and file backup of a Drupal or WordPress website. It autodetects the CMS and extracts the database credentials from the appropriate settings file.

**Usage:**

`website-backup.sh site-directory [db|file|full] [output-name-root] [output-directory]"`

**Notes:**

- The Drupal settings.php file parse for database credentials is fragile. It currently assumes the settings file is in the sites/default directory.
