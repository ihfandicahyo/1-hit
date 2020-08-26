#!/bin/bash

#////////////////////////////////////
# ql-installer
#////////////////////////////////////

ECMD="echo -e"
COLOUR_RESET='\e[0m'
aCOLOUR=(

		'\e[1;33m'	# Yellow	| symbol
		'\e[1m'		# Bold white	|
		'\e[1;32m'	# Green		| info
		'\e[1;31m'	# Red		|
		'\e[1;35m'	#		|

	)
	GREEN_LINE=" ${aCOLOUR[0]}─────────────────────────────────────────────────────$COLOUR_RESET"
	GREEN_BULLET=" ${aCOLOUR[2]}		[+]	$COLOUR_RESET"
	GREEN_WARN=" ${aCOLOUR[3]}            [!]     $COLOUR_RESET"


tools_deb() {
	$ECMD$aCOLOUR1$GREEN_LINE
	$ECMD $GREEN_BULLET "${aCOLOUR[2]}Updating Package ..."
	$ECMD$aCOLOUR1$GREEN_LINE
		apt update -y
		apt upgrade -y
		apt install curl wget net-tools nmap dmidecode lolcat ufw -y > /dev/null 2>&1 &
}

tools_rpm() {
	$ECMD$aCOLOUR1$GREEN_LINE
        $ECMD $GREEN_BULLET "${aCOLOUR[2]}Updating Package ..."
        $ECMD$aCOLOUR1$GREEN_LINE
                yes | yum update
                yes | yum upgrade
		yes | yum install curl wget net-tools nmap dmidecode ufw epel-release ruby > /dev/null 2>&1 &
}

req() {
        $ECMD$aCOLOUR1$GREEN_LINE
        $ECMD $GREEN_BULLET "${aCOLOUR[2]}Installing Requirements ..."
        $ECMD$aCOLOUR1$GREEN_LINE
                wget https://github.com/poseidon-network/qlauncher-linux/releases/latest/download/ql-linux.tar.gz -O ql.tar.gz > /dev/null 2>&1 &
                curl -o /usr/bin/Q https://raw.githubusercontent.com/pethot/1-hit/master/conf/Q > /dev/null 2>&1 &
                chmod +x /usr/bin/Q
}

docker() {
	$ECMD$aCOLOUR1$GREEN_LINE
        $ECMD $GREEN_BULLET "${aCOLOUR[2]}Installing Docker ..."
        $ECMD$aCOLOUR1$GREEN_LINE
		curl -sSL https://get.docker.com | sh
}

ql() {
        $ECMD$aCOLOUR1$GREEN_LINE
        $ECMD $GREEN_BULLET "${aCOLOUR[2]}Installing Qlauncher ..."
        $ECMD$aCOLOUR1$GREEN_LINE
	mkdir -p /etc/ql > /dev/null 2>&1 &
	tar -vxzf ql.tar.gz -C /etc/ql > /dev/null 2>&1 &
	rm ql.tar.gz
}

onboot() {
cat > /etc/systemd/system/qlauncher.service << EOF
[Unit]
Description=qlauncher.service
[Service]
Type=simple
ExecStart=/etc/ql/qlauncher.sh start
ExecStop=/etc/ql/qlauncher.sh stop
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
}

fw() {
	ufw start > /dev/null 2>&1 &
	ufw allow ssh > /dev/null 2>&1 &
	ufw allow 32440:32449/tcp > /dev/null 2>&1 &
	ufw allow 32440/tcp > /dev/null 2>&1 &
	ufw allow 32441/tcp > /dev/null 2>&1 &
	ufw allow 32442/tcp > /dev/null 2>&1 &
	ufw allow 32443/tcp > /dev/null 2>&1 &
	ufw allow 32444/tcp > /dev/null 2>&1 &
	ufw allow 32445/tcp > /dev/null 2>&1 &
	ufw allow 32446/tcp > /dev/null 2>&1 &
	ufw allow 32447/tcp > /dev/null 2>&1 &
	ufw allow 32448/tcp > /dev/null 2>&1 &
	ufw allow 32449/tcp > /dev/null 2>&1 &
	ufw allow 22/tcp > /dev/null 2>&1 &
	ufw allow 8080/tcp > /dev/null 2>&1 &
	ufw allow 5001/tcp > /dev/null 2>&1 &
	ufw allow 443/tcp > /dev/null 2>&1 &
	ufw allow 9096/tcp > /dev/null 2>&1 &
	ufw reload > /dev/null 2>&1 &
}

reload() {
	systemctl daemon-reload
	systemctl enable qlauncher
	systemctl start qlauncher
}

lolcat() {
	wget https://github.com/busyloop/lolcat/archive/master.zip > /dev/null 2>&1 &
	unzip master.zip > /dev/null 2>&1 &
	cd lolcat-master/bin
	gem install lolcat
	cd ; rm -rf lolcat-master
}

rpm() {
	tools_rpm ; req ; lolcat ; docker ; ql ; onboot ; fw ; reload
}

deb() {
	tools_deb ; req ; docker ; ql ; onboot ; fw ; reload
}

if [[ $(id -u) -ne 0 ]] ; then
        $ECMD $GREEN_WARN "${aCOLOUR[3]}Please run as root"
	exit 1
fi

  RPM=$(which yum)
  APT=$(which apt-get)

	if [[ ! -z $YUM ]]; then
    		rpm
		Q --about
	elif [[ ! -z $APT ]]; then
    		deb
		Q --about
	else
    		$ECMD $GREEN_WARN "${aCOLOUR[3]}Cant install"
    	exit 1 ;
 	fi
