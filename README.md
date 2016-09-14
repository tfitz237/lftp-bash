# lftp-bash
A [LFTP](https://github.com/lavv17/lftp) bash script that helps create an easy syncing workspace environment.

This script uses LFTP's `mirror` command to provide an easy sync with an FTP directory. It syncs all folders and files in the directory and updates each other with the newest files, while ignoring older files.

```bash
## Usage:  ftp.sh DIR ACTION [options]
## DIR:    Directory Name
## Action: 
##        -h, --help      Display this message
##        -d, --download  Download from server (default)
##        -u, --upload    Upload to server
##        -c, --config    FTP Configuration 
##Options:
##        --delete        Enables deletion of files not in sync with local files. Used in combination of -u"
````
### Initial setup
This bash script is dependent on LFTP so if you do not have it installed
```bash
sudo apt-get install lftp
```

To create a new directory and configuration, run the bash script
```bash
bash ftp.sh DIR #DIR is the name of the local directory that the script will sync in
```    
On first setup, a config directory will be created and a prompt will ask you to fill out the following information
* HOST
  * the FTP host IP/URL 
  * can include port via `host:port`, and `ftp://` or `sftp://` at the beginning
* USER
  * the FTP username
* REMOTE PATH
  * the FTP directory you wish to sync
* LOCAL PATH
  * the full path to the directory in which the synced directories will reside (defaults to current full path)
* SAVE PASSWORD
  * should the script save your password for later usage? 
* PASSWORD (IF SAVING)
  * the FTP password 
    
Once you finish the setup, the script will create a `.sh` file in a config directory. Then LFTP will begin mirroring the remote directory into a child directory of the `<DIRNAME`> used before.

### 

### To download from Remote -> Local
Run the bash script and it will mirror the remote directory with your local directory.

The script runs the `lftp mirror` command with the `--delete --verbose --newer-only` options enabled, which deletes any files locally that aren't in the remote, echos what files are being transferred, and only transfers new files ignoring older ones.
```bash
bash ftp.sh DIR 
# or
bash ftp.sh DIR -d
# or
bash ftp.sh DIR --download
```

### To upload from Local -> Remote
Run the bash script with the `-u` argument and it will upload your changes from the local directory to the remote directory.

The `lftp mirror` command has the `--verbose --newer-only` options enabled which echos what files are being transferred, and only transfers new files ignoring older ones.
```bash
bash ftp.sh DIR -u
# or
bash ftp.sh DIR --upload
```

#### Optional
`--delete` after -u/--upload enables deletion of files not in sync with local files.
```bash
bash ftp.sh DIR -u --delete
```

### To reconfigure an FTP Configuration
Run the bash script with `-c` argument and it will run the configuration again
```bash
bash ftp.sh DIR -c
# or
bash ftp.sh DIR --config
```

### To see the help page
```bash
bash ftp.sh -h
# or
bash ftp.sh DIR -h
# or
bash ftp.sh DIR --help
```

### Gulp
There is a gulp script included that should automatically find changes within subdirectories, and try to sync them based on the subdirectory's name. 

You will have to edit the `var localfolder` variable inside of the script to the full path to your workspace in order to ensure that the script finds the correct subdirectory name.


