#!/bin/bash
# recase_aws_tags.sh
# ------------------------------------------------------------------------------
# Description:
#   This scirpt changes the case of the first letter for all instance tag keys.
#
# ToDo:
#   - Make work with all resource types - should be simple (see line 162)
#   - Replace getops with getopt to support long option names...
# ------------------------------------------------------------------------------
# Help
# ------------------------------------------------------------------------------
show_help() {
cat << EOF

This script changes the case of the first letter of instance tag keys and
values as specified.

Usage: ${0##*/} [-Ulch] [-r REGION]
    -U   UPPERCASE      Uppercase all tags and uppercase all values.
    -l   LOWERCASE      Lowercase all tags and uppercase all values.
    -o   UP/LOW	        Uppercase all tags and lowercase all values.
    -m   MOVE           Rename a tag key (Copy tag value to new key && del old key)
                        This overwrites existing tags without confirmation
                        NOTE: See examples
    -c   CREDENTIALS    Prompt for credentials to override any existing awscli configuration.
    -r   REGION         Specify region to override any existing awscli configuration.
    -h   HELP           Show this help menu.

    Note: Exactly one (1) action flag (-U, -l, -Ul, -m) is required.

Requirements:
    Programs 'awscli' and 'jq' to be in your \$PATH, python 2.7
    AWS Access: AWS Access ID and Secret Access Keys

Examples:
    ./recase_aws_tags.sh -U -r us-east-1 # Uppercase tags in us-east-1
    ./recase_aws_tags.sh -m Project -m Application # Move Project tag values to Application tag.
    
EOF
exit 1
}

# ------------------------------------------------------------------------------
# Sanity (1/2)
# ------------------------------------------------------------------------------
# Check for arguments
[[ $# -le 0 ]] && show_help

# ------------------------------------------------------------------------------
# Arguments
# ------------------------------------------------------------------------------
# Handle options
OPTIND=1
while getopts "hUlom:cr:" opt; do
  case "$opt" in
    h)
      show_help
      ;;
    U)
      arg_U='set'
      ;;
    l)
      arg_l='set'
      ;;
    o)
      arg_Ul='set'
      ;;
    m)
      arg_m='set'
      arg_m_vals+=("$OPTARG")
      ;;
    c)
      arg_c='set'
      ;;
    r)
      arg_r="$OPTARG"
      ;;
    :)
      echo "ERROR: Option -$OPTARG requires an argument."
      show_help
      ;;
    *)
      echo "ERROR: Unknown Option."
      show_help
      ;;
  esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift

# ------------------------------------------------------------------------------
# Variables (1/2)
# ------------------------------------------------------------------------------
user=$(whoami)
awscli_config="$(eval echo "~$user")/.aws/config"
awscli_credentials="$(eval echo "~$user")/.aws/credentials"

# ------------------------------------------------------------------------------
# Sanity (2/2)
# ------------------------------------------------------------------------------
# Ensure exactly one action flag is passed
arg_count=0
[[ -n $arg_U ]] && ((arg_count++))
[[ -n $arg_l ]] && ((arg_count++))
[[ -n $arg_Ul ]] && ((arg_count++))
[[ -n $arg_m ]] && ((arg_count++))
if [[ $arg_count -ne 1 ]] ; then
  echo "ERROR: Only one action flag can be used at a time."
  show_help
fi

# Ensure, if moving, a src and dst are specified
if [[ -n $arg_m ]] ; then
  if [[ ! -n ${arg_m_vals[0]} || ! -n ${arg_m_vals[1]} ]] ; then
    echo "ERROR: Both a tag source key and tag destination key must be specified."
    show_help
  fi
fi

# Ensure aws region is available
if [[ -n $arg_r ]] ; then
  aws_region="$arg_r"
  awscli_region_check='pass'
elif [[ -f $awscli_config ]] ; then
  if [[ -n "$(grep 'region' "$awscli_config" | awk '{print $3}')" ]]; then
    aws_region="$(grep 'region' "$awscli_config" | awk '{print $3}')"
    awscli_region_check='pass'
  fi
fi

if [[ -z $awscli_region_check ]]
then
  echo "ERROR: AWS Region not found. Execute this script with -r, or run 'aws configure'"
  show_help
fi

# Ensure aws credentials are available
if [[ -n $arg_c ]] ; then
  read -pr "AWS Access Key ID: " aws_access_key_id
  read -pr "AWS Secret Access Key: " aws_secret_access_key
  awscli_credentials_check='pass'
elif [[ -f $awscli_credentials ]] ; then
  if [[ -n "$(grep 'key_id' "$awscli_credentials" | awk '{print $3}')" ]] ; then
    aws_access_key_id="$(grep 'key_id' "$awscli_credentials" | awk '{print $3}')"
    aws_secret_access_key="$(grep 'secret' "$awscli_credentials" | awk '{print $3}')"
    awscli_credentials_check='pass'
  fi
fi

if [[ -z $awscli_credentials_check ]]
then
  if [[ -z $arg_c ]] ; then
    echo "ERROR: AWS Credentials not found. Execute this script with -c, or run 'aws configure'"
    show_help
  fi
fi

# ------------------------------------------------------------------------------
# Variables (2/2)
# ------------------------------------------------------------------------------

export AWS_DEFAULT_REGION="$aws_region"
export AWS_ACCESS_KEY_ID="$aws_access_key_id"
export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
ts="$(date +"%FT%H-%M-%S%Z")"
instance_tags_initial_json="/tmp/instance_tags_initial.$ts.json"
instance_tags_post_op_json="/tmp/instance_tags_post_op.$ts.json"
log="${0##*/}.log"

# ------------------------------------------------------------------------------
# Main Operations
# ------------------------------------------------------------------------------
# Logging - yea, no logger
function startcheck {
  echo -e "$(date +"%F %T,%N")" - "START: $task" | tee -a "$log"
}
function resultcheck {
  if [[ $? -eq $1 ]] ; then
    echo -e "$(date +"%F %T,%N")" - "SUCCESS: $task" | tee -a "$log"
  else echo -e "$(date +"%F %T,%N")" - "ERROR: $task" | tee -a "$log"
  fi
}

task="Backup Instance Tags to $instance_tags_initial_json"
startcheck
aws ec2 describe-tags --filters "Name=resource-type,Values=instance" > "$instance_tags_initial_json"
resultcheck 0

task="Log Initial Tag Key Counts"
startcheck
jq -s 'map(.Tags[].Key)' "$instance_tags_initial_json" | tr -d '[]", ' | sed '/^\s*$/d' | \
sort | uniq -c | sort -r | awk '{sum += $1; print} END {print "   ", sum, "total"}' | tee -a "$log"
resultcheck 0

IFS_BAK=$IFS
IFS=$'\r\n'

task="Create Parsable Tag Array"
startcheck
tag_details_array=()
tag_details_array=($(jq -r '.Tags[] | "ResourceId:\(.ResourceId), Key:\(.Key), Value:\(.Value)"' "$instance_tags_initial_json" ))
resultcheck 0

task="Transform Tag Keys"
startcheck
# Note: $tag_details_array lines look like: 'ResourceId:i-f6e51251 Key:Name Value:MayassarGrayLog'
# tags that break this: 'ResourceId:i-78628bdf, Key:aws:autoscaling:groupName, Value:dcos-agent-yukon-dev'
# -f2-9 to compensate
for line in $(printf '%s\n' "${tag_details_array[@]}") ; do
  resource_id=$(echo "$line" | awk '{print $1}' | tr -d ',' | cut -d: -f2-9)
  key=$(echo "$line" | awk '{print $2}' | tr -d ',' | cut -d: -f2-9)
  value=$(echo "$line" | awk '{print $3}' | tr -d ',' | cut -d: -f2-9)

  # (-l) Lowercase keys and values
  if [[ -n $arg_l ]] ; then
    if [[ ${key:0:1} =~ [A-Z] ]] || [[ ${value:0:1} =~ [A-Z] ]] ; then
      if [[ ${key:0:1} =~ [A-Z] ]] ; then
        del_key='yes'
      fi
      new_key="$(tr '[:upper:]' '[:lower:]' <<< "${key:0:1}")$(tr '[:upper:]' '[:lower:]' <<< "${key:1}")"
      new_value="$(tr '[:upper:]' '[:lower:]' <<< "${value:0:1}")$(tr '[:upper:]' '[:lower:]' <<< "${value:1}")"
      update='yes'
    fi

  # (-U) Uppercase keys and values
  elif [[ -n $arg_U ]] ; then
    if [[ ${key:0:1} =~ [a-z] ]] || [[ ${value:0:1} =~ [a-z] ]] ; then
      if [[ ${key:0:1} =~ [a-z] ]] ; then
        del_key='yes'
      fi
      new_key="$(tr '[:lower:]' '[:upper:]' <<< "${key:0:1}")$(tr '[:upper:]' '[:lower:]' <<< "${key:1}")"
      new_value="$(tr '[:lower:]' '[:upper:]' <<< "${value:0:1}")$(tr '[:upper:]' '[:lower:]' <<< "${value:1}")"
      update='yes'
    fi

  # (-o) Uppercase keys and lowercase values
  elif [[ -n $arg_Ul ]] ; then
    if [[ ${key:0:1} =~ [a-z] ]] || [[ ${value:0:1} =~ [A-Z] ]] ; then
      if [[ ${key:0:1} =~ [a-z] ]] ; then
        del_key='yes'
      fi
      new_key="$(tr '[:lower:]' '[:upper:]' <<< "${key:0:1}")$(tr '[:upper:]' '[:lower:]' <<< "${key:1}")"
      new_value="$(tr '[:upper:]' '[:lower:]' <<< "${value:0:1}")$(tr '[:upper:]' '[:lower:]' <<< "${value:1}")"
      update='yes'
    fi

  # (-m) Rename a tag key (Move tag value to new key and delete old)
  elif [[ -n $arg_m ]] ; then
    if [[ "$key" == "${arg_m_vals[0]}" ]] ; then
      new_key="${arg_m_vals[1]}"
      new_value="$value"
      update='yes'
      del_key='yes'
    fi
  fi

  # Tag operations
  if [[ -n $update ]] ; then
    task="Update Tag on ResourceId:$resource_id, from: Key:$key, Value:$value, to: Key:$new_key, Value:$new_value"
    aws ec2 create-tags --resources "$resource_id" --tags Key="$new_key",Value="$new_value"
#echo "aws ec2 create-tags --resources $resource_id --tags Key=$new_key,Value=$new_value"
    # If successful AND key is changing then delete old tag
    if [[ $? -eq 0 ]] && [[ -n $del_key ]] ; then
      aws ec2 delete-tags --resources "$resource_id" --tags Key="$key"
#echo "aws ec2 delete-tags --resources $resource_id --tags Key=$key"
    fi
    resultcheck 0
  fi
  unset update
  unset del_key
  # Prevent aws api flooding
  sleep .15
done

task="Transform Tag Keys" # bc nested items
resultcheck 0

IFS=$IFS_BAK

task="Generate Post Operation Instance Tags to $instance_tags_post_op_json"
startcheck
aws ec2 describe-tags --filters "Name=resource-type,Values=instance" > "$instance_tags_post_op_json"
resultcheck 0

task="Log Resulting Tag Key Counts"
startcheck
jq -s 'map(.Tags[].Key)' "$instance_tags_post_op_json" | tr -d '[]", ' | sed '/^\s*$/d' | \
sort | uniq -c | sort -r | awk '{sum += $1; print} END {print "   ", sum, "total"}' | tee -a "$log"
resultcheck 0

echo "TAGGING COMPLETE: View full results in $log"
