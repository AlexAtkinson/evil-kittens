#!/bin/bash
# ----------------------------------------------------------------------
# /path/to/psshwrapper.sh
# Wrapper for pssh
#
# Notes:
#		jq and pssh must be installed
#		Runs commands against each hostgroup sequentially
#			Will parallize the pssh base commands instead
#		The $dir dir must exist in the same directory
#		The $dir dir must only contain valid hostgroup files
#
#		Todo:
#			Get list of servers, config servers, mongod servers
#
# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
log='psshtool.log'
dir='/home/centos/pssh/host-groups'
sshdir='/home/centos/.ssh' # Full path to ssh keys

mesosURI='mesos.uri:5050/state.json'
mesosUSER='mesos'

mesos_2URI='mesos_2.uri.:5050/state.json'
mesos_2USER='mesos'

# NOTICE ---------------------------
# The mongod hosts file is all hosts
# The mongod-masters and mongod-slaves are role defined
mongodServers=(172.16.4.{10..30})
mongodServers+=(172.16.4.{50..60})
mongodPrimaries=()
mongodSecondaries=()
mongodUSER='mongod'

# ----------------------------------------------------------------------
# Sanity Checks
# ----------------------------------------------------------------------
# if [ "$(whoami)" != root ] ; then
# 	echo -e "\nError: This script *must* be run as root!\n"
# 	exit 1
# fi

if [[ ! $(type jq) ]] ; then
  echo "ERROR: jq is not installed!"
  exit 1
fi

if [[ ! $(type pssh) ]] ; then
  echo "ERROR: pssh is not installed!"
  exit 1
fi

if [[ ! -e $dir ]] ; then
  echo "ERROR: $dir dir does not exist!"
  exit 1
fi

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
function resultCheck {
  if [[ $? -eq $1 ]] ; then
    echo -e "$(date +"%F %T,%N")" - "\e[00;32mSUCCESS\e[00m: $task" | \
    tee -a "$log"
  else echo -e "$(date +"%F %T,%N")" - "\e[00;31mERROR\e[00m: $task" | \
    tee -a "$log"
  fi
}

function ask {
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        elif [ "${2:-}" = "Range" ]; then # Range in format 1-n
            prompt="${3:-}"
            default=1
        else
            prompt="y/n"
            default=
        fi
        # Ask the question
        read -p $"$1 [$prompt]: " reply
        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi
        # Check if the reply is valid
        case "$reply" in
            Y*|y*|[1-9]*) return 0 ;;
            N*|n*|0*) return 1 ;;
        esac
    done
}

if [ $# -eq 0 ]
  then
    echo -e "No arguments supplied. Use -h to view the help.\n"
  else
    while test $# -gt 0 ; do
      case "$1" in
        -h|--help)
          echo "Use: psshwrapper.sh <options> -c 'command'"
          echo " "
          echo "options:"
          echo "-h, --help							print this help menu"
          echo "-l, --list							list available host groups"
          echo "-g, --group							specify host group"
          echo "-u, --update						update hosts files"
          echo " "
          exit 0
          ;;
        -l|--list)
          shift
            ls -1 $dir/
            exit 0
          shift
          ;;
        -g|--g)
          shift
            if test $# -gt 0 ; then
              for file in "$@" ; do
                if [ ! -f $dir/"$file" ] ; then
                  echo "ERROR $dir/$file does NOT exist?"
                  exit 1
                fi
              done
            else
              echo "ERROR: Host Group Not Specified!"
              exit 1
            fi
          shift
          ;;
        -c|--command)
          shift
            if test $# -gt 0 ; then
              cmd="$1"
            else
              echo "ERROR: Command NOT Specified! What are you doing?"
              exit 1
            fi
          shift
          ;;
        -u|--update)
          shift
            if ask "$(echo -e 'Update which hosts file?'\\\n\
            '1) v1 Mesos Agents'\\\n\
            '2) v1 Mesos Masters'\\\n\
            '3) v2 Mesos Agents'\\\n\
            '4) v2 Mesos Masters'\\\n\
            '5) MongoDB Primaries & Secondaries'\\\n\
            '6) All'\\\n\
            '0) Quit'\\\n\\\n\
            'Enter Reponse')" Range 0-6; then
              updateAnswer="$reply"
            else
              updateAnswer="$reply"
            fi
          shift
          ;;
        *)
          echo -e "Invalid argument. Use -h to view the help. Exiting...\n"
          break
          ;;
      esac
    done
fi

function getMesosLeader {
  task="Get Mesos Leader"
  mesosLeader=$(curl "$1" | jq '.leader' | tr -d '\"' | sed 's/master@//')
  resultCheck 0
}

function updatev1MesosAgents {
  task="Update v1 Mesos Agents Hosts File"
  getMesosLeader "$v1mesosURI"
  curl "$mesosLeader/state.json" | jq '.slaves[] .hostname' | tr -d '\"' | \
  sed 's/ip-//;s/.ec2.internal//;s/-/./g' | \
  awk '{ print "'"$v1mesosUSER@"'"$1 }' > "$dir"/v1mesos-agents
  resultCheck 0
}

function updatev1MesosMasters {
  task="Update v1 Mesos Masters Hosts File"
  curl "$v1mesosURI" | jq '.flags .zk' | \
  grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | \
  awk '{ print "'"$v1mesosUSER@"'"$1 }' > "$dir"/v1mesos-masters
  resultCheck 0
}

function updatev2MesosAgents {
  task="Update v2 Mesos Agents Hosts File"
  getMesosLeader "$v2mesosURI"
  curl "$mesosLeader/slaves" | jq '.slaves[] .hostname' | tr -d '\"' | \
  sed 's/ip-//;s/.ec2.internal//;s/-/./g' | \
  awk '{ print "'"$v2mesosUSER@"'"$1 }' > "$dir"/v2mesos-agents
  resultCheck 0
}

function updatev2MesosMasters {
  task="Update v2 Mesos Masters Hosts File"
  curl "$v2mesosURI" | jq '.flags .zk' | \
  grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | \
  awk '{ print "'"$v2mesosUSER@"'"$1 }' > "$dir"/v2mesos-masters
  resultCheck 0
}

function updateMongodb {
  task="Update MongoDB Primaries and Secondaries Hosts File"
  for host in "${mongodServers[@]}"
  do
          isprimary=$(mongo "$host":27017 --quiet --eval "printjson(db.isMaster().ismaster)")
          if [ "$isprimary" == 'true' ] ; then
                  mongodPrimaries+=("$host")
          else
                  mongodSecondaries+=("$host")
          fi
  done
  echo "${mongodPrimaries[@]}" | tr ' ' '\n' | awk '{ print "'"$mongodUSER@"'"$1 }' > "$dir"/mongod-primaries ; resultCheck 0
  echo "${mongodSecondaries[@]}" | tr ' ' '\n' | awk '{print "'"$mongodUSER@"'"$1 }' > "$dir"/mongod-secondaries ; resultCheck 0
}

function update {
  if [ "$updateAnswer" == '0' ] ; then
    echo -e "\nGet OUTTA here!"
    exit 1
  elif [ "$updateAnswer" == '1' ] ; then
    echo "Updating v1 Mesos Agents Host Group File..."
    updatev1MesosAgents
  elif [ "$updateAnswer" == '2' ] ; then
    echo "Updating v1 Mesos Masters Host Group File..."
    updatev1MesosMasters
  elif [ "$updateAnswer" == '3' ] ; then
    echo "Updating v2 Mesos Agents Host Group File..."
    updatev2MesosAgents
  elif [ "$updateAnswer" == '4' ] ; then
    echo "Updating v2 Mesos Masters Host Group File..."
    updatev2MesosMasters
  elif [ "$updateAnswer" == '5' ] ; then
    echo "Updatinv MongoDB Host Group File..."
    updateMongodb
  elif [ "$updateAnswer" == '6' ] ; then
     echo "Updating All Hosts Files..."
    updatev1MesosAgents
    updatev1MesosMasters
    updatev2MesosAgents
    updatev2MesosMasters
    updateMongodb
  fi
}

function execute {
  eval "$cmd"
  resultCheck 0
}

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------

update
# execute
