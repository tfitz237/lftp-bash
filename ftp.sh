#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'Please enter a directory name'
    exit 0
fi
PREFIX='lftp-bash'

DIR=${1%/}
if [ ! -d "$PREFIX-config" ]; then
    mkdir -p $PREFIX-ftp-config
fi
if [ ! -e "$PREFIX-config/$DIR-config.sh" ] ; then
    echo "<<First time setup for FTP site>>"
    read -e -p "FTP Host: " HOST
    read -e -p "FTP User: " USER
    read -e -p "FTP Password: " PASS
    read -e -p "Remote Directory: " REMOTEFOLDER
    read -e -p "Local Path: " -i "$PWD/" LOCALFOLDER 
    echo "HOST='$HOST'
USER='$USER'
PASS='$PASS'
REMOTEFOLDER='$REMOTEFOLDER'
LOCALFOLDER='$LOCALFOLDER'
    " >> "$PREFIX-config/$DIR-config.sh"
    if [ ! -d "$DIR" ]; then
        mkdir -p $LOCALFOLDER/$DIR
    fi
echo "--------------------------------------"
else
source "$PREFIX-config/$DIR-config.sh"
fi


if [ "$2" = "up" ] 
then
echo "Syncing from Local --> Remote
------------------------------"
lftp -e "
open $HOST
user $USER $PASS
lcd $LOCALFOLDER 
mirror --reverse --delete --verbose --only-newer $DIR/$REMOTEFOLDER $REMOTEFOLDER
bye
"
echo "Done."
else
echo "Syncing from Remote --> Local
------------------------------"
lftp -e "
open $HOST
user $USER $PASS
lcd $LOCALFOLDER
mirror --delete  --verbose --only-newer $REMOTEFOLDER $DIR/
bye
" 
echo "Done."
fi
