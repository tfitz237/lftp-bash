# lftp-bash
A LFTP bash script that helps create an easy syncing workspace environment.

### Initial setup
To create a new directory and configuration, run the bash script
```bash
bash ftp.sh <DIRNAME> #DIRNAME can be a nickname to the FTP server/folder you are going to be syncing
```    
On first setup, a config directory will be created and a prompt will ask you to fill out the following information
* HOST
  * the FTP host IP/URL 
  * can include port via `host:port`, and `ftp://` or `sftp://` at the beginning
* USER
  * the FTP username
* PASS
  * the FTP password 
* REMOTEFOLDER
  * the FTP directory you wish to sync 
* LOCALFOLDER
  * the full path to the directory in which the synced directories will reside (defaults to current full path)   
    
Once you finish the setup, the script will create a `.sh` file in a config directory. Then LFTP will begin mirroring the remote directory into a child directory of the `<DIRNAME`> used before.

### To download from Remote -> Local
Run the bash script and it will mirror the remote directory with your local directory.

The `lftp mirror` command has the `--delete --verbose --newer-only` options enabled, which deletes any files locally that aren't in the remote, echos what files are being transferred, and only transfers new files ignoring older ones.
```bash
bash ftp.sh <DIRNAME>
```

### To upload from Local -> Remote
Run the bash script with the `up` argument and it will upload your changes from the local directory to the remote directory.

The `lftp mirror` command has the `--delete --verbose --newer-only` options enabled, which deletes any files remotely that aren't in your local directory, echos what files are being transferred, and only transfers new files ignoring older ones.
```bash
bash ftp.sh <DIRNAME> up
```

