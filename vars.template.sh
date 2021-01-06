# Variable descriptions are in README.md.

# Server Connection variables
SERVERUSERNAME="user"
LOCALSERVERDOMAIN="192.168.0.18"
LOCALSERVERSSHPORT="22"
SERVERDOMAIN="home.user.dev"
SERVERSSHPORT="9999"
SERVERPATH="/media/hdd/Main"

# Restic and B2 config. varaibles
B2_ACCOUNT_ID="ACC_ID_HERE"
B2_ACCOUNT_KEY="ACC_KEY_HERE"
RESTIC_PASSWORD=""
TARGETBUCKET="Main-Restic"
LOCALPATH="/home/user/Main"
REMOTEPATH="/Main"
RETENTIONPOLICY="--keep-last 3 --keep-weekly 3 --keep-monthly 3 --keep-yearly 3"
BACKUPOPTIONS="--exclude \".stversions\""