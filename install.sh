#!/bin/bash

#////////////////////////////////////
# ql-installer
#////////////////////////////////////

ECMD="echo -e"
COLOUR_RESET='\e[0m'
aCOLOUR=(

		'\e[1;33m'	# Yellow	| symbol
		'\e[1m'		# Bold white	|
		'\e[1;32m'	# Green		|
		'\e[1;31m'      # Red

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
		apt install curl wget net-tools nmap dmidecode lolcat ufw -y
}

tools_rpm() {
	$ECMD$aCOLOUR1$GREEN_LINE
        $ECMD $GREEN_BULLET "${aCOLOUR[2]}Updating Package ..."
        $ECMD$aCOLOUR1$GREEN_LINE
                yes | yum update
                yes | yum upgrade
		yes | yum install epel-release curl wget net-tools nmap dmidecode unzip ruby
}

req() {
        $ECMD$aCOLOUR1$GREEN_LINE
        $ECMD $GREEN_BULLET "${aCOLOUR[2]}Installing Requirements ..."
        $ECMD$aCOLOUR1$GREEN_LINE
                wget https://github.com/poseidon-network/qlauncher-linux/releases/latest/download/ql-linux.tar.gz -O ql.tar.gz 
                curl -o /usr/bin/Q https://raw.githubusercontent.com/pethot/1-hit/master/conf/Q
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
	mkdir -p /etc/ql
	tar -vxzf ql.tar.gz -C /etc/ql
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
	yes | ufw enable
	ufw allow ssh
	ufw allow 32440:32449/tcp
	ufw allow 32440/tcp
	ufw allow 32441/tcp
	ufw allow 32442/tcp
	ufw allow 32443/tcp
	ufw allow 32444/tcp
	ufw allow 32445/tcp
	ufw allow 32446/tcp
	ufw allow 32447/tcp
	ufw allow 32448/tcp
	ufw allow 32449/tcp
	ufw allow 22/tcp
	ufw allow 8080/tcp
	ufw allow 5001/tcp
	ufw allow 443/tcp
	ufw allow 9096/tcp
	ufw reload
}

reload() {
	systemctl daemon-reload
	systemctl enable qlauncher
	systemctl start qlauncher
}

lolcat() {
	wget https://github.com/busyloop/lolcat/archive/master.zip
	unzip master.zip
	cd lolcat-master/bin
	gem install lolcat
	cd ; rm -rf lolcat-master
}

rpm() {
	tools_rpm ; req ; lolcat ; docker ; yum install ufw -y ; ql ; onboot ; fw ; systemctl stop docker ; systemctl start docker ; systemctl enable docker ; reload ; clear >> install.log
}

deb() {
	tools_deb ; req ; docker ; ql ; onboot ; fw ; reload ; clear >> install.log 
}

if [[ $(id -u) -ne 0 ]] ; then
        $ECMD $GREEN_WARN "${aCOLOUR[3]}Please run as root $COLOUR_RESET"
	exit 1
fi

  RPM=$(which yum)
  APT=$(which apt-get)

	if [[ ! -z $RPM ]]; then
    		rpm
		Q --about
	elif [[ ! -z $APT ]]; then
    		deb
		Q --about
	else
    		$ECMD $GREEN_WARN "${aCOLOUR[3]}Can't install $COLOUR_RESET"
    	exit 1 ;
 	fi
