#!/bin/bash

VER=0.4.0
DAT=12.04.2012


F18_ISTALL_BIN=/opt/knowhowERP/bin
F18_ISTALL=/opt/knowhowERP/util
ARCH=`uname -m`
DELRB_VER="1.0"
PTXT_VER="1.55"
F18_VER="0.9.95"

echo "F18 install app ver: $VER, dat: $DAT"
echo "---------------------------------------------------"

echo "F18 req."

#sudo apt-get update
#sudo apt-get install libqt4-sql-psql

sudo apt-get -y install wine winetricks
sudo apt-get -y install vim-gtk
sudo apt-get -y install wget 
sudo apt-get -y install langpack-si-base 
winetricks -q  riched20


echo " postoji li F18 install dir"

for f in $F18_INSTALL $F18_INSTALL_BIN
if [[ -d $f ]]; then

	echo "F18 instalaciona lokacija postoji, nastavljam" 
else
    echo "kreiram F18 install dir $f"
 	mkdir -p  $f
    chown $USER
fi


echo " instaliram F18"

CUR_DIR=`pwd`

TMP_DIR=/tmp



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

D_FILE=F18_Ubuntu_${ARCH}_${F18_VER}.gz
wget -nc http://knowhow-erp-f18.googlecode.com/files/$D_FILE
cp -av $D_FILE $TMP_DIR


echo "kopiram utils" 

cd $CUR_DIR
cp -av util/* $F18_ISTALL

if [[ !-f ~/.vimrc ]]; then
  cp -av util/.vimrc ~/.vimrc
else
  echo "~/.vimrc postoji, necu ga kopirati"
fi

cd $TMP_DIR
gzip -dNf ptxt_$PTXT_VER.gz
gzip -dNf delphirb_$DELRB_VER.gz

bunzip2 -f ptxt_fonts.tar.bz2
tar xvf ptxt_fonts.tar

cp -av ptxt.exe ~/.wine/drive_c/
cp -av delphirb.exe ~/.wine/drive_c/

cp -av ptxt_fonts/*.ttf  ~/.wine/drive_c/windows/Fonts/

chmod +x $F18_ISTALL/ptxt
chmod +x $F18_ISTALL/f18_editor


echo "kopiram F18 bin"

gzip -dNf F18_Ubuntu_${ARCH}_${F18_VER}.gz
cp -av F18 $F18_INSTALL_BIN


for f in ~/.wine/drive_c ~/.wine/drive_c/windows/Fonts $F18_INSTALL $F18_INSTALL_BIN
do
  DIR=$f
  echo $DIR
  echo ---------------------------------------
  ls -l $DIR
  echo " "
done



