#! /bin/sh
# /etc/init.d/whatami.sh
### BEGIN INIT INFO
# Provides:          whatami
# Required-Start:    $local_fs $syslog
# Required-Stop:
# Should-Start:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Use instance tags for self-discovery & build
# Description:       Uses 'Component' & Roles' tag values to get
#                    build file from artifacts server & execute.
### END INIT INFO

# Setup:
# 1. Create this file
# 2. chmod 755 /etc/init.d/whatami.sh
# 3. chown root:root /etc/init.d/whatami.sh
# 4. ln -s /etc/init.d/whatami.sh /etc/rc5.d/S05whatami.sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

do_start() {

	source /etc/profile
	base_url='http://deploy.server/build'
	build_file='/root/scripts/build.sh'

	instance_id=$(ec2-metadata -i | cut -d ' ' -f2)
#	To debug, uncommnet & set valid instance ID
#	instance_id=i-6c9f0def
	instance_tags=$(ec2-describe-tags \
		--region "us-east-1" \
		--filter "resource-type=instance" \
		--filter "resource-id=${instance_id}" \
		--aws-access-key "asdfasdfasdfasdf" \
		--aws-secret-key "asdfasdfasdfasdf" \
		| grep 'Role\|Component' \
		| cut -f4-5 --output-delimiter " " \
		| tr '[:upper:]' '[:lower:]')
	
	IFS=$'\n'
	tags=(${instance_tags})

	for i in "${tags[@]}"; do
		if [[ ${i} == *component* ]] ; then
			component=$(echo ${i} | awk '{print $2}')
		elif [[ ${i} == *role* ]]; then
			role=$(echo ${i} | awk '{print $2}')
	done

	unset IFS

	build_script=$base_url/$component/$role.sh
	wget $build_script -O $build_file
	chmod +x $build_file
	bash $build_file

    # Disable this script
    rm /etc/rc5.d/S05whatami.sh
}

case "$1" in
  start|"")
        do_start
        ;;
  stop|status)
        ;;
  *)
        echo "Usage: whatami.sh [start|stop]" >&2
        exit 3
        ;;
esac
