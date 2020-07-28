#!/bin/bash


r='\e[31m\e[1m'
y='\e[33m\e[1m'
g='\e[32m\e[1m'
w='\e[39m'
alpha='abcdefghijklmnopqrstuvwxyz+/ABCDEFGHIJKLMNOPQRSTUVWXYZ'
alphalen=54


install() {
    echo -ne "    dpkg ${y}$1${w}\r"
    apt install -y $1 1>/dev/null 2>/dev/null && \
    echo -e  "    dpkg ${g}$1${w}                       "
}


start() {
        echo -e "${g}[+]${w} Generating KEY"
        for i in {1..2048}; do
                echo -ne ${alpha[@]:$(shuf -i 0-$alphalen -n 1):1} >> .temp
        done

        echo -ne "${g}[+]${w} Generating HASH"
        md5=$(md5sum .temp |cut -d " " -f1)
        rm -f .temp
        sleep 1
        echo " ${md5}"

        echo -e "${g}[+]${w} Installing apache2 services..."

        install apache2
        install php
        install libapache2-mod-php
        install php-cli

        service apache2 enable 1>/dev/null 2>/dev/null && \
        service apache2 restart 1>/dev/null 2>/dev/null

        src_php=$(ls -1 |grep php)
        src_upd=$(cat ${src_php} |grep '_uploads' |cut -d '"' -f2)
        src_err=$(cat ${src_php} |grep '_err'     |cut -d '"' -f2 |cut -d '/' -f1)

        dst_php="$(echo -ne ${md5} |cut -c1-20).php"
        dst_upd="$(echo -ne ${md5} |cut -c21-32)_uploads"
        dst_err="$(echo -ne ${md5} |cut -c21-32)_err"

        sed -i "s^${src_upd}^${dst_upd}^g" $src_php
        sed -i "s^${src_err}^${dst_err}^g" $src_php

        echo -e "${g}[+]${w} Installing package in apache2 directory /var/www/html"
        cp index.html /var/www/html/index.html
        cp ${src_php} /var/www/html/${dst_php}
        mkdir /var/www/html/${dst_upd}
        mkdir /var/www/html/${dst_err}

        chmod 777 /var/www/html/${dst_upd}
        chmod 777 /var/www/html/${dst_err}

        IP=$(ip route | grep default | cut -d " " -f9)

        echo -e "${g}[+]${w} All done. "
        echo -e "    Your PHP: ${g}${dst_php}${w}"
        echo -e "    Your URL: http://${IP}/${dst_php}"
}


start
