#! /bin/bash

NUMBER_OF_SPLIT_LINES=10000
SPLIT_FILE_PREFIX='small-'
BIG_FILE_PATH=master.csv
SPLIT_FILES=$SPLIT_FILE_PREFIX*

COMMAND_COLOR='\033[0;36m'
HIGHLIGHT_COLOR='\033[0;33m'
NO_COLOR='\033[0m' # No Color

# cd_split_folder () {
#   cd regions/
# }

split_big_csv_into_small_chunks () {
  header=$(head -1 $BIG_FILE_PATH)
  echo -e "Parsing the HEADER"
  echo -e "${HIGHLIGHT_COLOR}$header${NO_COLOR}"

  # Separate the data from the header
  echo -e "\nMoving the data file out"
  echo -e "${COMMAND_COLOR}tail -n +2 $BIG_FILE_PATH > output.data${NO_COLOR}"
  tail -n +2 $BIG_FILE_PATH > output.data

  echo -e "\nSplit $BIG_FILE_PATH file into small chunks with size $NUMBER_OF_SPLIT_LINES lines..."
  echo -e "${COMMAND_COLOR}split -l $NUMBER_OF_SPLIT_LINES output.data $SPLIT_FILE_PREFIX${NO_COLOR}"
  split -l $NUMBER_OF_SPLIT_LINES output.data $SPLIT_FILE_PREFIX
}

add_header_row_split_files () {
  for part in `ls -1 $SPLIT_FILE_PREFIX*`
  do
    printf "%s\n%s" "$header" "`cat $part`" > $part
  done
}

add_csv_extension_to_split_files () {
  for part in `ls -1 $SPLIT_FILE_PREFIX*`
  do
    mv ${part} ${part}.csv
  done
}

# cd_split_folder
split_big_csv_into_small_chunks
add_header_row_split_files
add_csv_extension_to_split_files

echo -e "\nCleaning ...."
rm output.data