#!/bin/bash
#
# Create a symbolic link in the ~/bin directory for the specified file.
#
Version=1.0.0

usage() {
  echo ""
  echo "linktobin.sh V$Version"
  echo ""
  echo "Link the specified file into the user's ~/bin directory."
  echo "   P1: Target file (file being linked to"
  echo "   P2: Option link name (defaults to target file name if not specified"
  echo ""
  echo "Usage:"
  echo ""
  echo "   linktobin.sh target_file [link_name]"
  echo "   linktobin.sh website-backup.sh                : Creates ~/bin/website-backup.sh -> website-backup.sh"
  echo "   linktobin.sh website-backup.sh website_backup : Creates ~/bin/website-backup    -> website-backup.sh"
  echo ""
}

checkForBinDir() {
  if [[ ! -d ~/bin ]]
  then
    read -rp "There is no ~/bin directory, create it? (y/n): " Response
    if [[ ! $Response =~ ^[yY]$ ]]
    then
      mkdir ~/bin
    else
      exit
    fi
  fi
}

fileTests() {
  filePath=$1
  linkName=$2

  if [[ ! -r $filePath ]]; then
    echo "Could not find file: $filePath"
    exit 1
  fi;

  if [[ ! -x $filePath ]]; then
    read -rp "File is not executable. Make executable with chmod u+x? (y/n): " Response
    if [[ $Response =~ ^[yY]$ ]]
    then
      chmod u+x "$filePath"
    fi;
  fi;

  if [[ -r ~/bin/$linkName && ! -L ~/bin/$linkName ]]; then
    echo "A file already exists with the name $linkName"
    exit 1
  fi;

  if [[ -L ~/bin/$linkName ]]; then
    if [ "$(readlink ~/bin/$linkName)" == "$(readlink $filePath)" ]; then
      echo "  $linkName exists and is linked to the correct file"
      exit
    else
      echo "  $linkName exists but does not link to $filePath"
      echo "  $(ls -al ~/bin/$linkName)"
      exit 1
    fi;
  fi;
}

linkFile() {
  cd ~/bin || exit
  ln -s "$1" "$2"
}

main() {
  if [ "$1" = "" ]; then
    usage
    exit 1
  fi;
  targetFile="$(pwd)/$1"

  if [ "$2" = "" ]; then
    linkName=$(basename "$1")
  else
    linkName="$2"
  fi;

  checkForBinDir
  fileTests "$targetFile" "$linkName"
  linkFile "$targetFile" "$linkName"
}

main "${1-}" "${2-}"
