#!/bin/bash

VER=1.0.1
DAT=25.03.2012


F18_INSTALL_ROOT=/opt/knowhowERP

ARCH=`uname -m`
DELRB_VER="1.0"
PTXT_VER="1.55"
F18_VER="0.9.66"
HBOUT_VER="3.1.0"


CUR_DIR=`pwd`

TMP_DIR=/tmp/knowhowERP
mkdir -p $TMP_DIR

#OWNER=`logname`
#OWNER=`who am i | awk '{print $1}'`

if [[ "$USER" == "root" ]]; then
   OWNER=$SUDO_USER
else
   OWNER=$USER
fi

LOG_F=$TMP_DIR/F18_3rd.log

echo `date` > $LOG_F
echo ------------------------------------------- >> $LOG_F
echo PATH=$PATH >> $LOG_F
echo CUR_DIR=$CUR_DIR >> $LOG_F
echo TMP_DIR=$TMP_DIR >> $LOG_F
echo HOME=$HOME, OWNER=$OWNER, SUDO_USER=$SUDO_USER, USER=$USER >> $LOG_F


echo "F18 install app ver: $VER, dat: $DAT"
echo "F18 install app ver: $VER, dat: $DAT" >> $LOG_F

echo "---------------------------------------------------"

INSTALL_HBOUT=0

PARAM=$1

if [ "$PARAM" = "--hbout" ]
then
   INSTALL_HBOUT=1
fi

DIR=$F18_INSTALL_ROOT/util
sudo mkdir -p $DIR
sudo chown $OWNER.$OWNER $DIR


DIR=$F18_INSTALL_ROOT/lib
sudo mkdir -p $DIR
sudo chown $OWNER.$OWNER $DIR


DIR=$F18_INSTALL_ROOT/bin
sudo mkdir -p $DIR
sudo chown $OWNER.$OWNER $DIR

echo `ls -l -d $F18_INSTALL_ROOT/bin` >> $LOG_F 
echo `ls -l -d $F18_INSTALL_ROOT/util` >> $LOG_F 
echo `ls -l -d $F18_INSTALL_ROOT/lib` >> $LOG_F 

sudo cp -av profile.d/F18_knowhowERP.sh /etc/profile.d/


echo "F18 req."

PACKAGES="wget libqt4-sql-psql wine winetricks vim-gtk"

for PKG in $PACKAGES
do

sudo apt-get -y install $PKG
echo apt-get install $PKG, exit=$? >> $LOG_F

done

winetricks -q  riched20


echo " postoji li F18 install dir"

echo " instaliram F18"
DOWNLOAD_DIR=~/Downloads
mkdir -p $DOWNLOAD_DIR

cd $DOWNLOAD_DIR

D_FILE=F18_Ubuntu_${ARCH}_${F18_VER}.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
echo wget $D_FILE , exit $? >> $LOG_F
cp -av $D_FILE $TMP_DIR

D_FILE=delphirb_$DELRB_VER.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
echo wget $D_FILE , exit $? >> $LOG_F
cp -av $D_FILE $TMP_DIR

D_FILE=ptxt_$PTXT_VER.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
echo wget $D_FILE , exit $? >> $LOG_F
cp -av $D_FILE $TMP_DIR

D_FILE=ptxt_fonts.tar.bz2
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
echo wget $D_FILE , exit $? >> $LOG_F
cp -av $D_FILE $TMP_DIR

D_FILE=adslocal.tar.bz2
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
echo wget $D_FILE , exit $? >> $LOG_F
cp -av $D_FILE $TMP_DIR

if [[ $INSTALL_HBOUT -eq 1 ]]
then
  D_FILE=harbour_ubuntu_${ARCH}_${HBOUT_VER}.tar.bz2
  wget -nc http://knowhow-erp.googlecode.com/files/$D_FILE
  echo wget $D_FILE , exit $? >> $LOG_F
  cp -av $D_FILE $TMP_DIR
fi


echo "kopiram utils" 

cd $CUR_DIR
sudo cp -av util/* $F18_INSTALL_ROOT


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

FILE=F18_Ubuntu_${ARCH}_${F18_VER}
gzip -dNf $FILE.gz

cp -av F18 $F18_INSTALL_ROOT/bin/
chmod +x $F18_INSTALL_ROOT/bin/F18

echo cp F18, exit=$? >> $LOG_F 

if [[ $INSTALL_HBOUT -eq 1 ]]
then
   F_NAME=harbour_ubuntu_${ARCH}_${HBOUT_VER}
   bunzip2 -f $F_NAME.tar.bz2
   tar xvf $F_NAME.tar
   sudo mv hbout /opt/knowhowERP/
   sudo chown -R $OWNER.$OWNER /opt/knowhowERP/hbout
fi

chmod +x $F18_INSTALL_ROOT/util/*
chmod +x $F18_INSTALL_ROOT/bin/*


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

