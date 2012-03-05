#!/bin/bash

VER=0.1.0
DAT=14.12.2011
F18INSTALL=/opt/knowhowERP/util
ARCH=`uname -m`
DELRB_VER="1.0"
PTXT_VER="1.55"
F18_VER="0.9.18"
echo "F18 install app ver: $VER, dat: $DAT"
echo "F18 lin installacija ...."



echo "F18 req."

#sudo apt-get update
#sudo apt-get install libqt4-sql-psql

sudo apt-get -y install wine winetrics
sudo apt-get -y install vim-gtk
sudo apt-get -y install wget 
winetricks -q  riched20


echo " postoji li F18 install dir"

if [ -d $F18INSTALL ]; then

	echo "F18 instalaciona lokacija postoji, nastavljam" 
else
        echo "kreiram F18 install dir"
 	mkdir -p  $F18INSTALL
fi

echo " instaliram F18"

mkdir tmp 
cd tmp 

#wget -N http://knowhow-erp-f18.googlecode.com/files/F18_Ubuntu_"$ARCH"_"$F18_VER".gz
wget -N http://knowhow-erp-f18.googlecode.com/files/delphirb_$DELRB_VER.gz
wget -N http://knowhow-erp-f18.googlecode.com/files/ptxt_$PTXT_VER.gz

gzip -dNf ptxt_$PTXT_VER.gz
gzip -dNf delphirb_$DELRB_VER.gz
#gzip -dN F18_Ubuntu_"$ARCH"_"$F18_VER".gz

cp F18 $F18INSTALL
chmod +x $F18INSTALL/F18
cd ..

echo "kopiram utils" 

cp -av util/ptxt  $F18INSTALL
cp -av tmp/ptxt.exe ~/.wine/drive_c/
cp -av tmp/delphirb.exe ~/.wine/drive_c/
cp -av fonts/ptxt_fonts/*.ttf  ~/.wine/drive_c/windows/Fonts/
cp -av util/F18_ubuntu_update  $F18INSTALL
cp util/f18_editor $F18INSTALL

chmod +x $F18INSTALL/ptxt
chmod +x $F18INSTALL/f18_editor

#echo ".....OK zavrsio sa kopiranjem"

#echo "setujem envars"

#echo export PATH=\$PATH:~/bin >> ~/.bash_profile
#echo ""
#echo ""
#echo "F18 instalacija zavrsena, pokrecemo iz terminala sa F18 "



