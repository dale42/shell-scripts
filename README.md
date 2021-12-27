# Utility Shell Scripts

A collection of shells scripts for doing routine stuff on the command line.

## Overview

| Script | Description |
| --- | --- |
| dropalltables | Drop all tables in a database |
| linktobin.sh  | Link file into ~/bin directory |
| make-wp-site.sh | Make a fully configured WordPress site |
| restore-db.sh | Restore a sql dump file, compresses or uncompressed, to a database | 
| website-backup.sh | Database and file backup of a Drupal or WordPress website |

## dropalltables

Drop all the tables in the specified database.

**Usage:**

`dropalalltables username password database`

**Notes:**

- Assumes the host is localhost
- This will leave the database password on the command line history. If this is a concern, use the  `history -c` command to clear thie history, or use the technique described in this stackoverflow article: [Execute command without keeping it in history](https://stackoverflow.com/questions/8473121/execute-command-without-keeping-it-in-history)

## linktobin.sh

Link the specified file into the ~/bin directory.

A convenience script that wraps `ln -s` with some checking before linking the target file into
the ~/bin directory.

- **P1: Target file**\
  File being linked to
- **P2: Link name** (Optional)\
  Defaults to target file name if not specified

**Usage:**

```bash
linktobin.sh target_file [link_name]

# Create ~/bin/website-backup.sh -> website-backup.sh"
linktobin.sh website-backup.sh

# Create ~/bin/website-backup -> website-backup.sh
linktobin.sh website-backup.sh website_backup
```

## make-wp-site.sh

Make a fully set-up WordPress in a LAMP environment.

**Usage:**

`wp-site-create`

Prompts for required parameters.

**Notes:**

- Requires wp-cli (wp) and mysql command line utilities

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
