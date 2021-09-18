# Import vars. and funcs.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HERE"/vars.sh
source "$HERE"/lib.sh

# Ask if Restic should run from remote server
echo "Connect to remote server? Y/N"
read remoteInput
if [ $remoteInput == 'y' ] || [ $remoteInput == 'Y' ]; then
	REMOTE=1
fi

# Determine connection to remote server if needed
if [ "$REMOTE" == 1 ]; then
	echo 'Server Restic Backup'
	echo 'Testing Server Connection...'
	serverFindConnection
	echo 'Connection found.'
else
	echo 'Local Restic Backup'
fi

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
	1) # Backup (if remote, run asynchronously and give option to view logs)
		INITCOMMAND="init"
		DATE="$(date +"%Y-%m-%d-%H-%M")"

		if [ "$REMOTE" == 1 ]; then
			BACKUPCOMMAND="backup $SERVERPATH -v $BACKUPOPTIONS"
			resticRemoteCommand "$INITCOMMAND" 2>/dev/null
			resticRemoteCommand "$BACKUPCOMMAND" 1
		else
			BACKUPCOMMAND="backup $LOCALPATH -v $BACKUPOPTIONS"
			resticLocalCommand "$INITCOMMAND" 2>/dev/null
			resticLocalCommand "$BACKUPCOMMAND"
		fi
		;;
	2) # Forget
		if [ "$REMOTE" == 1 ]; then
			resticRemoteCommand "forget ${RETENTIONPOLICY}"
		else
			resticLocalCommand "forget ${RETENTIONPOLICY}"
		fi
		;;
	3) #Prune (if remote, run asynchronously and give option to view logs)
		PRUNECOMMAND="prune"
		DATE="$(date +"%Y-%m-%d-%H-%M")"
		if [ "$REMOTE" == 1 ]; then
			resticRemoteCommand "$PRUNECOMMAND" 1
		else
			resticLocalCommand "$PRUNECOMMAND"
		fi
		;;
	4) # List
		if [ "$REMOTE" == 1 ]; then
			resticRemoteCommand "snapshots"
		else
			resticLocalCommand "snapshots"
		fi
		;;
	5) # Check
		if [ "$REMOTE" == 1 ]; then
			resticRemoteCommand "check"
		else
			resticLocalCommand "check"
		fi
		;;
	6) # Mount
		if [ ! -d ~/resticBackup ]; then mkdir ~/resticBackup; fi
		if [ "$REMOTE" == 1 ]; then
			echo "Not available for remote server."
		else
			resticLocalCommand "mount /home/$(whoami)/resticBackup" && ~/resticBackup
		fi
		;;
	7) # Freeform
		echo 'Enter the Restic command: '
		read RC
		if [ "$REMOTE" == 1 ]; then
			resticRemoteCommand "${RC}"
		else
			resticLocalCommand "${RC}"
		fi
		;;
	*)
		exit
		;;
	esac
done
