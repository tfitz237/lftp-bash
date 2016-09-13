#!/bin/bash
PREFIX='tif'
if [ ! -d "$PREFIX-ftp-config" ]; then
    mkdir -p $PREFIX-ftp-config
fi
if [ ! -d "$1" ]; then
    mkdir -p $1
fi
if [ ! -e "$PREFIX-ftp-config/${1%/}-config.sh" ] ; then
    echo "<<First time setup for FTP site>>"
    read -e -p "FTP Host: " HOST
    read -e -p "FTP User: " USER
    read -e -p "FTP Password: " PASS
    read -e -p "Remote Directory: " REMOTEFOLDER
    read -e -p "Local Path: " -i "/home/ubuntu/workspace/" LOCALFOLDER 
    echo "HOST='$HOST'
USER='$USER'
PASS='$PASS'
REMOTEFOLDER='$REMOTEFOLDER'
LOCALFOLDER='$LOCALFOLDER'
    " >> "$PREFIX-ftp-config/${1%/}-config.sh"
fi
source "$PREFIX-ftp-config/${1%/}-config.sh"

if [ "$2" = "up" ] 
then
echo "Syncing from Local --> Remote"
lftp -e "
open $HOST
user $USER $PASS
lcd $LOCALFOLDER 
mirror --reverse --delete --verbose --only-newer $LOCALFOLDER$REMOTEFOLDER $REMOTEFOLDER
bye
"
else
echo "Syncing from Remote --> Local"
lftp -e "
open $HOST
user $USER $PASS
lcd $LOCALFOLDER 
mirror --delete  --verbose --only-newer $REMOTEFOLDER $LOCALFOLDER
bye
" 
fi
