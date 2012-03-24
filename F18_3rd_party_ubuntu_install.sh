#!/bin/bash

VER=0.6.0
DAT=24.03.2012


F18_ISTALL=/opt/knowhowERP/util
ARCH=`uname -m`
DELRB_VER="1.0"
PTXT_VER="1.55"
F18_VER="0.9.18"
HBOUT_VER="3.1.0"

echo "F18 install app ver: $VER, dat: $DAT"
echo "---------------------------------------------------"



DIR=/opt/knowhowERP/util
sudo mkdir -p $DIR
sudo chown $USER.$USER $DIR


DIR=/opt/knowhowERP/lib
sudo mkdir -p $DIR
sudo chown $USER.$USER $DIR


DIR=/opt/knowhowERP/bin
sudo mkdir -p $DIR
sudo chown $USER.$USER $DIR



echo "F18 req."

#sudo apt-get update
#sudo apt-get install libqt4-sql-psql

sudo apt-get -y install wine winetricks
sudo apt-get -y install vim-gtk
sudo apt-get -y install wget 
winetricks -q  riched20


echo " postoji li F18 install dir"

if [ -d $F18_ISTALL ]; then

	echo "F18 instalaciona lokacija postoji, nastavljam" 
else
        echo "kreiram F18 install dir"
 	mkdir -p  $F18_ISTALL
fi

echo " instaliram F18"

CUR_DIR=`pwd`

TMP_DIR=/tmp/knowhowERP
mkdir -p $TMP_DIR


#wget -N http://knowhow-erp-f18.googlecode.com/files/F18_Ubuntu_"$ARCH"_"$F18_VER".gz

DOWNLOAD_DIR=~/Downloads
mkdir -p $DOWNLOAD_DIR

cd $DOWNLOAD_DIR

D_FILE=delphirb_$DELRB_VER.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
cp -av $D_FILE $TMP_DIR

D_FILE=ptxt_$PTXT_VER.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
cp -av $D_FILE $TMP_DIR

D_FILE=ptxt_fonts.tar.bz2
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
cp -av $D_FILE $TMP_DIR

D_FILE=adslocal.tar.bz2
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
cp -av $D_FILE $TMP_DIR

D_FILE=harbour_ubuntu_${ARCH}_${HBOUT_VER}.tar.bz2
wget -nc http://knowhow-erp.googlecode.com/files/$D_FILE
cp -av $D_FILE $TMP_DIR


echo "kopiram utils" 

cd $CUR_DIR
cp -av util/* $F18_ISTALL


cd $TMP_DIR
gzip -dNf ptxt_$PTXT_VER.gz
gzip -dNf delphirb_$DELRB_VER.gz

bunzip2 -f ptxt_fonts.tar.bz2
tar xvf ptxt_fonts.tar

bunzip2 -f adslocal.tar.bz2
tar xvf adslocal.tar

cp -av lib/* ~/.wine/drive_c/

cp -av ptxt.exe ~/.wine/drive_c/
cp -av delphirb.exe ~/.wine/drive_c/

cp -av ptxt_fonts/*.ttf  ~/.wine/drive_c/windows/Fonts/

F_NAME=harbour_ubuntu_${ARCH}_${HBOUT_VER}
bunzip2 -f $F_NAME.tar.bz2
tar xvf $F_NAME.tar
mv hbout /opt/knowhowERP/

chmod +x $F18_ISTALL/ptxt
chmod +x $F18_ISTALL/f18_editor


echo " "
DIR=~/.wine/drive_c
echo $DIR
echo ---------------------------------------
ls -l $DIR

echo " "
DIR=~/.wine/drive_c/windows/Fonts
echo $DIR
echo ---------------------------------------
ls -l $DIR

echo " "
DIR=/opt/knowhowERP/util
echo $DIR
echo ---------------------------------------
ls -l $DIR

