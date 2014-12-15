#!/bin/bash
#Script d'installation automatique d'Asterisk 11 et de DAHDI
##Rajout du choix de version d'Asterisk (11 ou 1.8)
##Installation de googleTTS
#Installation d'Asterisk 11.X avec Meetme, les sons en français et de DAHDI
echo "Installation des dépendances"
sleep 2
apt-get update && apt-get -y upgrade
apt-get -y install build-essential libxml2-dev libncurses5-dev linux-headers-`uname -r` libsqlite3-dev libssl-dev perl libwww-perl sox mpg123
echo "Quelle version d'Asterisk souhaitez vous installer?"
echo "1: Version 11.x.x"
echo "2: Version 1.8.xx.x"
read choice
echo "Téléchargement et installation de DAHDI"
sleep 2
mkdir /usr/src/asterisk
cd /usr/src/asterisk
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
tar xvzf dahdi-linux-complete-current.tar.gz
cd dahdi-linux-complete*
make all
make install
make config
/etc/init.d/dahdi start
case $choice in
1)
echo "Téléchargement et installation d'asterisk 11.x.x"
sleep 2
cd /usr/src/asterisk
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-11-current.tar.gz
tar xvzf asterisk-11-current.tar.gz
cd asterisk-11*
./configure
make menuselect.makeopts
menuselect/menuselect --enable app_meetme --enable CORE-SOUNDS-FR-ULAW --enable MOH-OPSOUND-ULAW --enable EXTRA-SOUNDS-FR-ULAW menuselect.makeopts
make
make install
make samples
make config
/etc/init.d/asterisk start
;;
2)
echo "Téléchargement et installation d'asterisk 1.8.xx.x"
sleep 2
cd /usr/src/asterisk
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-1.8-current.tar.gz
tar xvzf asterisk-1.8-current.tar.gz
cd asterisk-1.8*
./configure
make menuselect.makeopts
menuselect/menuselect --enable app_meetme --enable CORE-SOUNDS-FR-ULAW --enable MOH-OPSOUND-ULAW --enable EXTRA-SOUNDS-FR-ULAW menuselect.makeopts
make
make install
make samples
make config
/etc/init.d/asterisk start
;;
esac
echo "Installation de google TTS"
sleep 2
cd /var/lib/asterisk/agi-bin
wget https://raw.github.com/zaf/asterisk-googletts/master/googletts.agi
chmod +x googletts.agi
echo "On lance la console d'asterisk"
sleep 2
asterisk -cvvvvvvvvvvr
exit
