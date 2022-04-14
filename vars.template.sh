# Variable descriptions are in README.md.

# Restic and B2 config. varaibles
B2_ACCOUNT_ID="ACC_ID_HERE"
B2_ACCOUNT_KEY="ACC_KEY_HERE"
RESTIC_PASSWORD=""
TARGETBUCKET="Main-Restic"
LOCALPATH="/home/user/Main"
REMOTEPATH="/Main"
RETENTIONPOLICY="--keep-last 3 --keep-weekly 3 --keep-monthly 3 --keep-yearly 3"
BACKUPOPTIONS="--exclude \".stversions\""