#!/bin/bash

# Set the date format that we want to use
DATE_FORMAT="%Y-%m-%d"

# Move .mov and .heic files to a directory named "originals" in a subdirectory named from it's creation date,
# and pre-pend the creation date to the file name. If the file is a .heic file, create a jpg version of the file
# in the dated subdirectory.
for file in *.mov *.MOV *.heic *.HEIC *.AAE
do
  if [ ! -f "$file" ]; then
    continue
  fi

  file_date=$(stat -f "%SB" -t "$DATE_FORMAT" "$file")
  originals_dir="$file_date/originals"
  file_name="${file%.*}"
  file_extension="${file##*.}"
  new_file_name="$file_date-$file_name"
  new_file_name_1024="$file_date-1024-$file_name"

  if [ ! -d "$originals_dir" ]; then
      mkdir -p "$originals_dir"
  fi

  mv "$file" "$originals_dir/$new_file_name.$file_extension"

  if [ "$file_extension" == "HEIC" ]; then
    # Create a jpg version of the heic file
    sips -s format jpeg "$originals_dir/$new_file_name.$file_extension" --out "$file_date/$new_file_name.jpg" > /dev/null
    sips -s format jpeg "$originals_dir/$new_file_name.$file_extension" --out "$file_date/$new_file_name_1024.jpg" -Z 1024 > /dev/null
  fi
done

# Move any remaining files in a subdirectory named from the file's creation date.
for file in *; do
  if [ ! -f "$file" ]; then
    continue
  fi

  file_date=$(stat -f "%SB" -t "$DATE_FORMAT" "$file")

  if [ ! -d "$file_date" ]; then
      mkdir -p "$file_date"
  fi

  mv "$file" "$file_date/$file_date-$file"
done
