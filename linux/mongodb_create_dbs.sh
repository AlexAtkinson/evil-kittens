#!/bin/bash
# ----------------------------------------------------------------------
# genDbs.sh
#
# Use:
#     ./genDbs.sh genDbs.csv
#
# CSV Format:
#     [database]
#
# ----------------------------------------------------------------------

# Create a bunch of DBs and insert woots
while read line
do
    mongo admin --eval "db.getSiblingDB('blarg')"
    mongo $line --eval "db.$line.insert( { 'say':'woot' } )"
done < $1
