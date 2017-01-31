#!/bin/bash
# ----------------------------------------------------------------------
# Sanity Checks
# ----------------------------------------------------------------------
user="<USER>"
dir="/<...>/scripts"

if [ "$(whoami)" != $user ] ; then
    echo -e "\nError: This script *must* be run as $user!\n"
    exit 1
fi

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
function resultcheck {
  if [ $? -eq "$1" ] ; then
    echo -e "artifact-sync: SUCCESS: $task" | logger
  else
    echo -e "artifact-sync: ERROR: $fault - $task" | logger
    error='true'
    errors+=("$fault - $task")
  fi
}

# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
s3prefix='s3://'
dir='/artifacts'
envs=('' 'prod' 'stag' 'dev')
inventory_file="inventory-<REPLACE>"
tmp_dir='/tmp'
tmp_file="$tmp_dir/$inventory_file"
inv_file="$dir/$inventory_file"
errors=()

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-east-1

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------
aws s3 cp $s3prefix/"$inventory_file" $tmp_file

# Create dirs if they don't exist
for env in "${envs[@]}"
do
  task="Create $dir/$env"
  if [ ! -d $dir/"$env" ] ; then mkdir $dir/"$env" && chmod 755 $dir/"$env" && resultcheck 0 ; fi
done

# Ensure local inventory file exists
if [ ! -f $inv_file ] ; then
  cp $tmp_file $inv_file
  initial_sync='true'
fi

# Check for differences between local/remote inventory
if [[ $initial_sync != true ]] ; then
  if [[ $(md5sum "$tmp_file" | cut -d' ' -f1) == \
        $(md5sum "$inv_file" | cut -d' ' -f1) ]] ; then
    while read line
    do
      [[ -z $line ]] && continue
      line=($line)

      if [[ ! -f $dir/${line[0]}/${line[1]} ]] ; then
        continue='true'
        break
      fi
    done<"$tmp_file"
    if [[ $continue != 'true' ]] ; then
      exit 0
    fi
  fi
fi

# Sync artifacts
while read line
do
  [[ -z $line ]] && continue
  line=($line)

  if [[ ! -f $dir/${line[0]}/${line[1]} ]] ; then
    task="Initial get for ${line[0]} ${line[1]} ${line[2]}"
    /usr/bin/aws s3 cp $s3prefix/"${line[0]}"/"${line[1]}" $dir/"${line[0]}" ; resultcheck 0
  else
    remote_ver=${line[2]}
    local_ver=$(grep "${line[1]}" "$inv_file" | grep "${line[0]}" | awk '{print $3}')
    if [[ $remote_ver != $local_ver ]]; then
      task="Get ${line[0]} ${line[1]} ${line[2]}"
      /usr/bin/aws s3 cp $s3prefix/"${line[0]}"/"${line[1]}" "$dir"/"${line[0]}"/"${line[1]}".download ; resultcheck 0
      task="Replace local ${line[0]} ${line[1]} version $local_ver with ${line[2]}"
      if [[ $(md5sum $dir/"${line[0]}"/"${line[1]}".download | cut -d' ' -f1) == \
            "${line[3]}" ]] ; then
        mv -f $dir/"${line[0]}"/"${line[1]}".download $dir/"${line[0]}"/"${line[1]}" ; resultcheck 0
      else
        fault='md5sum check'
        false ; resultcheck 0
        fault=''
      fi
    fi
  fi
done<"$tmp_file"

if [[ $error == 'true' ]] ; then
  task_list=$(printf "%s\n" "${errors[@]}")
  task="-------------------------------------\n \
TASK FAILURE SUMMERY:\n \
$task_list\n \
WARNING: Inventory file NOT updated!\n \
--------------------------------------------------------------"
  false ; resultcheck 0
else
  task="Update local inventory file"
  cp "$tmp_file" "$inv_file" ; resultcheck 0
fi
