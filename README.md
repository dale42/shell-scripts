# Utility Shell Scripts

A collection of shells scripts for doing routine stuff on the command line.

## Overview

| Script | Description |
| --- | --- |
| ddev-drupalcreate.sh | Creates a Drupal 9 site in DDEV |
| dropalltables | Drop all tables in a database |
| restore-db.sh | Restore a sql dump file, compresses or uncompressed, to a database | 
| website-backup.sh | Database and file backup of a Drupal or WordPress website |

## ddev-drupalcreate.sh

Creates a Drupal 9 site in DDEV.

**Usage:**

`ddev-drupalcreate [directory]`

**Notes:**

- `directory` is created in the current working directory
- Only tested on a Mac
- The DDEV http/https ports are changed to 8080 and 8043 to avoid conflicts with other http daemons
- DDEV Mutagen is enabled (because Mac)
- A number of common Drupal modules are added (e.g.: devel, admin_toobar)

## dropalltables

Drop all the tables in the specified database.

**Usage:**

`dropalalltables username password database`

**Notes:**

- Assumes the host is localhost
- This will leave the database password on the command line history. If this is a concern, use the  `history -c` command to clear thie history, or use the technique described in this stackoverflow article: [Execute command without keeping it in history](https://stackoverflow.com/questions/8473121/execute-command-without-keeping-it-in-history)


#restore-db.sh

Restores a sqldump or gzipped sqldump file to the specified database.

`restore-db.sh username password database sql-file.sql`

**Notes:**
- Assumes the host is localhost
- This will leave the database password on the command line history. If this is a concern, use the  `history -c` command to clear thie history, or use the technique described in this stackoverflow article: [Execute command without keeping it in history](https://stackoverflow.com/questions/8473121/execute-command-without-keeping-it-in-history)


## website-backup.sh

A general purpose script for taking a database, file, or database and file backup of a Drupal or WordPress website. It autodetects the CMS and extracts the database credentials from the appropriate settings file.

**Usage:**

`website-backup.sh site-directory [db|file|full] [output-name-root] [output-directory]`

**Notes:**

- The Drupal settings.php file parse for database credentials is fragile. It currently assumes the settings file is in the sites/default directory.
