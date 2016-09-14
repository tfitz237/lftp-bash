#!/bin/bash
helpme() {
echo "<< LFTP-BASH >>
Usage:  ftp.sh DIR ACTION [options]
    
DIR:    Directory Name
Action: 
        -h, --help      Display this message
        -d, --download  Download from server (default)
        -u, --upload    Upload to server
        -c, --config    FTP Configuration 
Options:
        --delete        Enables deletion of files not in sync with local files. Used in combination of -u"
}

config() {
    echo "<< FTP Configuration >>
-----------------------------"
    read -e -p "FTP Host: " -i "$HOST" HOST
    read -e -p "FTP User: " -i "$USR" USR
    read -e -p "Remote Path: " -i "$REMOTEFOLDER" REMOTEFOLDER
    if [ -z $LOCALFOLDER]; then 
        LOCALFOLDER="$PWD/"
    fi
    read -e -p "Local Path: " -i "$LOCALFOLDER" LOCALFOLDER     
    read -e -p "Save Password? (yes/y/no/n): " -i "$SAVE" SAVE
    if [ "$SAVE" = "y" ] || [ "$SAVE" = "yes" ]; then
        read -e -p "FTP Password: " -i "$PASS" PASS
        echo "HOST='$HOST'
USR='$USR'
PASS='$PASS'
REMOTEFOLDER='$REMOTEFOLDER'
LOCALFOLDER='$LOCALFOLDER'
SAVE='$SAVE'" > "$PREFIX-config/$DIR-config.sh"
    else
        echo "HOST='$HOST'
USR='$USR'
REMOTEFOLDER='$REMOTEFOLDER'
LOCALFOLDER='$LOCALFOLDER'
SAVE='$SAVE'" > "$PREFIX-config/$DIR-config.sh"
    fi
}

if [[ $# -eq 0 ]] ; then
    echo 'Please enter a directory name. -h for help'
    exit 0
fi
if [[ $1 == -* ]]; then
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    helpme
    fi
    exit 0
fi

PREFIX='lftp-bash'
DIR=${1%/}

if [ ! -d "$PREFIX-config" ]; then
    mkdir -p $PREFIX-config
fi
if [ ! -e "$PREFIX-config/$DIR-config.sh" ] ; then
    config
    if [ ! -d "$DIR" ]; then
        mkdir -p $LOCALFOLDER/$DIR
    fi
echo "-----------------------------"
else
    source "$PREFIX-config/$DIR-config.sh"
fi

download() 
{
    echo "<< Syncing from Remote --> Local >>
-----------------------------"
    lftp -e "
    open $HOST
    user $USR $PASS
    lcd $LOCALFOLDER
    mirror --delete --verbose --only-newer $REMOTEFOLDER $DIR/
    bye
    " 
    echo "Sync Complete."    
}

upload() 
{
    echo "<< Syncing from Local --> Remote >>
-----------------------------"
    if [ "$3" = "--delete" ]; then
        lftp -e "
        open $HOST
        user $USR $PASS
        lcd $LOCALFOLDER 
        mirror --reverse --delete --verbose --only-newer $DIR/$(basename $REMOTEFOLDER)/ $(dirname $REMOTEFOLDER)/
        bye
        "
    else
        lftp -e "
        open $HOST
        user $USR $PASS
        lcd $LOCALFOLDER 
        mirror --reverse --verbose --only-newer $DIR/$(basename $REMOTEFOLDER)/ $(dirname $REMOTEFOLDER)/
        bye
        "
    fi
    echo "Sync Complete."
}


case "$2" in
-h|--help)
helpme;;
-c|--config)
config;;
-u|--upload)
upload;;
-d|--download|*)
download
esac


