#!/bin/bash

Setting_node_information(){
	clear;echo "设定服务端信息:"
	read -p "(1/3)前端地址:" Front_end_address
	read -p "(2/3)节点ID:" Node_ID
	read -p "(3/3)Mukey:" Mukey
	if [[ ${Mukey} = '' ]];then
		Mukey='mupass';echo "未设置该项,默认Mukey值为:mupass"
	fi
	echo;echo "Great！即将开始安装...";echo;sleep 2.5
}

install_node_for_debian(){
	apt-get -y update;apt-get install -y wget curl git lsof python-pip build-essential
	cd /root;wget "http://ssr-1252089354.coshk.myqcloud.com/libsodium-1.0.15.tar.gz"
	tar xf /root/libsodium-1.0.15.tar.gz;cd /root/libsodium-1.0.15;./configure;make -j2;make install;cd /root
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf;ldconfig
	
	pip install cymysql requests -i https://pypi.org/simple/
	wget -O /usr/bin/shadowsocks "https://file.52ll.win/ssr";chmod 777 /usr/bin/ssr
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	cd shadowsocks;chmod +x *.sh;pip install -r requirements.txt -i https://pypi.org/simple/
	cp apiconfig.py userapiconfig.py;cp config.json user-config.json
	
	sed -i "17c WEBAPI_URL = \'${Front_end_address}\'" /root/shadowsocks/userapiconfig.py
	sed -i "2c NODE_ID = ${Node_ID}" /root/shadowsocks/userapiconfig.py
	sed -i "18c WEBAPI_TOKEN = \'${Mukey}\'" /root/shadowsocks/userapiconfig.py
}

Setting_node_information
install_node_for_debian