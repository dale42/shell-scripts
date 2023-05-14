# Utility Shell Scripts

A collection of shells scripts for doing routine stuff on the command line.

## Overview

| Script                  | Description                                                                       |
|-------------------------|-----------------------------------------------------------------------------------|
| ddev-drupalcreate.sh    | Moved to [GitHub: dale42/ddev-scripts](https://github.com/dale42/ddev-scripts)    |
| dropalltables           | Drop all tables in a database                                                     |
| photo-rename-convert.sh | Put HIEC and MOV files in directory based on creation date and create JPG version |
| restore-db.sh           | Restore a sql dump file, compresses or uncompressed, to a database                | 
| website-backup.sh       | Database and file backup of a Drupal or WordPress website                         |

## dropalltables

Drop all the tables in the specified database.

**Usage:**

`dropalalltables username password database`

**Notes:**

- Assumes the host is localhost
- This will leave the database password on the command line history. If this is a concern, use the  `history -c` command to clear thie history, or use the technique described in this stackoverflow article: [Execute command without keeping it in history](https://stackoverflow.com/questions/8473121/execute-command-without-keeping-it-in-history)

## photo-rename-convert.sh

Process images files in a directory renaming and organizing them based on their creation date, and create jpg versions of HEIC files. This is intended for use on files transferred from an iPhone.

**Usage:**

`photo-rename-convert.sh`

**Notes:**

For each file in the current directory do the following:

- If the file extension is .heic or .mov, move the file to a directory named {creation-date}/original, where _creation-date_ is the creation date of the file\
  e.g. 2023-05-14/original
- If the file has any other extension, move the file to a directory named {creation-date}, where _creation-date_ is the creation date of the file
- If the file extension is .heic, create a .jpg version of the file in the {creation-date} directory at its current size and at a width of 1024 pixels

## restore-db.sh

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
