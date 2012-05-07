#!/bin/bash

VER=1.2.1
DAT=13.04.2012

TMP_DIR=/tmp/knowhowERP
mkdir -p $TMP_DIR

F18_INSTALL_ROOT=/opt/knowhowERP

GCODE_URL_ROOT_F18=http://knowhow-erp-f18.googlecode.com/files
GCODE_URL_ROOT=http://knowhow-erp.googlecode.com/files

LOG_F=$TMP_DIR/F18_update.log

WHOAMI=`whoami`
USER="bringout"

SERVICE='F18'
ARCH=`uname -m`

if [[ "$USER" == "root" ]]; then
   OWNER=$SUDO_USER
else
   OWNER=$USER
fi

DOWNLOAD_DIR=~/Downloads
mkdir -p $DOWNLOAD_DIR

#szAnswer=$(zenity --entry --text "where are you?" --entry-text "at home"); echo $szAnswer
#ls -lah ~/github | column | zenity --text-info --width 530 --height 350

ans=$(zenity --list \
    --text "Odaberite operaciju koju želite uraditi: " \
    --checklist \
    --column "Označi" \
    --column "Operacija" \
    --column "Opis" \
    TRUE "update" "F18 update" \
    FALSE "template" "Instalacija/update predložaka" \
    --separator=":" \
    --width 450 --height 200 ); 
#echo $ans

if [[ "$ans" =~ "update" && "$ans"!="" ]]; then
    if ps ax | grep -v grep | grep -w $SERVICE > /dev/null
    then
	zenity --error --title="Greška!" --text="Da bi ste izvršili nadogradnju morate zatvoriti $SERVICE!"
	exit 0
    fi

    cd $DOWNLOAD_DIR
    F18_VER=$(zenity --entry --title="Unos verzije za update" --text="Unesite verziju F18 na koju želite nadograditi:" --entry-text="1.0.");

    #ako je korisnik odustao od downloada, prekini izvršenje skripte
    if [ $? -eq 1 ]; then
	exit 0
    fi

    D_FILE=F18_Ubuntu_${ARCH}_${F18_VER}.gz
    #echo $D_FILE

#Download fajla
    wget -q -nc "$GCODE_URL_ROOT_F18/$D_FILE" 2>&1 | \sed -u 's/^.* \+\([0-9]\+%\) \+\([0-9.]\+[GMKB]\) \+\([0-9hms.]\+\).*$/\1\n# Downloading... \2 (\3)/' | \zenity --progress --title='Download' --auto-close

    #Ukolikno download nije uspješan tj. fajl nije pronađen na trenutnoj lokaciji stavi to u log file
    if [ ! -f $D_FILE ]; then
	zenity --error --title="Greška!" --text="Nije pronađen fajl $D_FILE"
	echo "Fajl $D_FILE nije pronađen." >> $LOG_F
	exit 0
    fi
    #Počni update
    (
	echo "20" ; sleep 1
	echo "# Kopiram $D_FILE u privremeni direktorij..."; sleep 1
	cp -av $D_FILE $TMP_DIR

    # $? is shell variable that contains outcome of last ran command
    # cp will return 0 if there was no error
	if [ $? -eq 0 ]; then
	    echo 'copied succesfully' >> $LOG_F
	else
	    echo 'copying was not seccesfull' >> $LOG_F
	fi

	echo "40" ; sleep 1
	echo "# Raspakujem arhivu..."; sleep 1
	cd $TMP_DIR
	FILE=F18_Ubuntu_${ARCH}_${F18_VER}
	gzip -dNf $FILE.gz
	if [ $? -eq 0 ]; then
	    echo 'Fajl uspješno otpakovan' >> $LOG_F
	else
	    echo 'Greška prilikom otpakivanja arhive' >> $LOG_F
	fi

	echo "70" ; sleep 1
	echo "# Vršim update F18..."; sleep 1
	mv F18 $FILE

	echo "90" ; sleep 1
	echo "# Dodjeljujem potrebne permisije "; sleep 1
	chmod +x $FILE

	echo "100" ; sleep 1
	echo "# Update je uspješno završen" ; sleep 1

    ) | zenity --progress \
	--title="F18 update" \
	--text="Započinjem update F18..." \
	--percentage=0
    if [ "$?" = -1 ]; then
	zenity --error \
	    --text="Update otkazan. Dogodila se greška."
    fi
fi
if [[ "$ans" =~ "template" && "$ans" != "" ]]; then
    zenity --info --title="Answer" --text="Instaliram predloške..."
fi