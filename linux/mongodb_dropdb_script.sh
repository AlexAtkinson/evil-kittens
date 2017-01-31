#!/bin/bash
# ----------------------------------------------------------------------
# dropDbs.sh
#
# Use:
#     ./dropDbs.sh dbs.csv
#
# CSV Format:
#     [database] <identifier>
#     Note: The identifier is simply to... identify the DB with a human
#           readable name in the output, and is optional.
#
# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
log=dropDbs.log

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
function resultcheck {
  if [ $? -eq $1 ] ; then echo -e "$TASK: \e[00;32mSUCCESS\e[00m" | tee -a $log ; else echo -e "$TASK: \e[00;31mERROR\e[00m" | tee -a $log ; fi
}

# ----------------------------------------------------------------------
# Arrays
# ----------------------------------------------------------------------

# Get array of DBs from MongoDB
dbArray=( $(mongo admin --eval 'printjson(db.runCommand("listDatabases"))' | grep name | awk '{ printf $3"\n" }' |  sed 's/"//g' | sed 's/,//') )

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------

# If DB exists, then drop
while read line
do
    DB=$( echo $line | awk '{ print $1 }' )
    CUST=$( echo $line | awk '{ print $2 }' )

    for i in "${dbArray[@]}"
    do
#echo "DB = $DB"
#echo "i = $i"
        if [ $i == $DB ] ; then
            echo -e "\n$DB Exists."
            TASK="Delete $CUST DB $DB"
            echo -e "\n$TASK..." #; resultcheck 0
            mongo $DB --eval 'db.dropDatabase();' ; resultcheck 0
        fi
    done
done < $1
