#!/bin/bash

VER=0.7.5
DAT=25.03.2012


F18_ISTALL_ROOT=/opt/knowhowERP

ARCH=`uname -m`
DELRB_VER="1.0"
PTXT_VER="1.55"
F18_VER="0.9.64"
HBOUT_VER="3.1.0"

echo "F18 install app ver: $VER, dat: $DAT"
echo "---------------------------------------------------"

INSTALL_HBOUT=0

PARAM=$1

if [ "$PARAM" = "--hbout" ]
then
   INSTALL_HBOUT=1
fi

DIR=$F18_INSTALL_ROOT/util
sudo mkdir -p $DIR
sudo chown $USER.$USER $DIR


DIR=$F18_INSTALL_ROOT/lib
sudo mkdir -p $DIR
sudo chown $USER.$USER $DIR


DIR=$F18_INSTALL_ROOT/bin
sudo mkdir -p $DIR
sudo chown $USER.$USER $DIR


sudo cp -av profile.d/F18_knowhowERP.sh /etc/profile.d/


echo "F18 req."

sudo apt-get -y install libqt4-sql-psql
sudo apt-get -y install wine winetricks
sudo apt-get -y install vim-gtk
sudo apt-get -y install wget 
winetricks -q  riched20


echo " postoji li F18 install dir"

echo " instaliram F18"

CUR_DIR=`pwd`

TMP_DIR=/tmp/knowhowERP
mkdir -p $TMP_DIR



DOWNLOAD_DIR=~/Downloads
mkdir -p $DOWNLOAD_DIR

cd $DOWNLOAD_DIR

D_FILE=F18_Ubuntu_$ARCH_$F18_VER.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE


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

if [[ $INSTALL_HBOUT -eq 1 ]]
then
  D_FILE=harbour_ubuntu_${ARCH}_${HBOUT_VER}.tar.bz2
  wget -nc http://knowhow-erp.googlecode.com/files/$D_FILE
  cp -av $D_FILE $TMP_DIR
fi


echo "kopiram utils" 

cd $CUR_DIR
sudo cp -av util/* $F18_ISTALL


cd $TMP_DIR
gzip -dNf ptxt_$PTXT_VER.gz
gzip -dNf delphirb_$DELRB_VER.gz

bunzip2 -f ptxt_fonts.tar.bz2
tar xvf ptxt_fonts.tar

bunzip2 -f adslocal.tar.bz2
tar xvf adslocal.tar

sudo cp -av lib/* ~/.wine/drive_c/

cp -av ptxt.exe ~/.wine/drive_c/
cp -av delphirb.exe ~/.wine/drive_c/

cp -av ptxt_fonts/*.ttf  ~/.wine/drive_c/windows/Fonts/

FILE=F18_Ubuntu_$ARCH_$F18_VER
gzip -dNf $FILE.gz
cp -av F18 $F18_INSTALL_ROOT/bin/
chmod +x $F18_INSTALL_ROOT/bin/F18

if [[ $INSTALL_HBOUT -eq 1 ]]
then
   F_NAME=harbour_ubuntu_${ARCH}_${HBOUT_VER}
   bunzip2 -f $F_NAME.tar.bz2
   tar xvf $F_NAME.tar
   sudo mv hbout /opt/knowhowERP/
   sudo chown -R $USER.$USER /opt/knowhowERP/hbout
fi

sudo chmod +x $F18_ISTALL/ptxt
sudo chmod +x $F18_ISTALL/f18_editor


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

