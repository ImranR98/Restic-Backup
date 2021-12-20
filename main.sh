# Import vars. and funcs.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HERE"/vars.sh
source "$HERE"/lib.sh

echo 'Restic Backup'

# Ask for Restic password if env. var. not provided
resticAskPass

# Present choices on loop
while [ true ]; do
	echo ''
	echo "Pick an action: "
	echo '1) Backup'
	echo '2) Forget'
	echo '3) Prune'
	echo '4) List Backup Snapshots'
	echo '5) Check Backup Integrity'
	echo '6) Mount'
	echo '7) Freeform'
	echo '*) Exit'

	read choice
	case $choice in
	1) # Backup
		INITCOMMAND="init"
		DATE="$(date +"%Y-%m-%d-%H-%M")"
		BACKUPCOMMAND="backup $LOCALPATH -v $BACKUPOPTIONS"
		resticLocalCommand "$INITCOMMAND" 2>/dev/null
		resticLocalCommand "$BACKUPCOMMAND"
		;;
	2) # Forget
		resticLocalCommand "forget ${RETENTIONPOLICY}"
		;;
	3) #Prune
		PRUNECOMMAND="prune"
		DATE="$(date +"%Y-%m-%d-%H-%M")"
		resticLocalCommand "$PRUNECOMMAND"
		;;
	4) # List
		resticLocalCommand "snapshots"
		;;
	5) # Check
		resticLocalCommand "check"
		;;
	6) # Mount
		if [ ! -d ~/resticBackup ]; then mkdir ~/resticBackup; fi
		resticLocalCommand "mount /home/$(whoami)/resticBackup" && ~/resticBackup
		;;
	7) # Freeform
		echo 'Enter the Restic command: '
		read RC
		resticLocalCommand "${RC}"
		;;
	*)
		exit
		;;
	esac
done
