# Import vars. and funcs.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$HERE"/vars.sh
source "$HERE"/lib.sh

echo 'Server Restic Backup'
echo 'Testing Server Connection...'
serverFindConnection
echo 'Connection found.'
echo ''
echo "Pick an action: "
echo '1) Backup'
echo '2) List Backup Snapshots'
echo '3) Check Backup Integrity'
echo '4) Freeform'
echo '*) Exit'

read choice	
case $choice in	
	1)
		DATE="$(date +"%Y-%m-%d-%H-%M")"
    	resticCommand "init"  2>/dev/null
    	resticCommand "backup $LOCALPATH -v --exclude \".stversions\" > ~/restic-backup-$DATE.log" &
		echo "Command is being run asynchronously on the Server, with output saved in the home directory. Attempt to print output? Y/N"
		read printOutput
		if [ $printOutput == 'y' ] || [ $printOutput == 'Y' ]; then sleep 3; serverCommand "tail -f ~/restic-backup-$DATE.log"; fi
		;;	
	2)
		resticCommand "forget ${RETENTIONPOLICY}"
		;;
	3)
		DATE="$(date +"%Y-%m-%d-%H-%M")"
		resticCommand "prune > ~/restic-prune-$DATE.log" &
		echo "Command is being run asynchronously on the Server, with output saved in the home directory. Attempt to print output? Y/N"
		read printOutput
		if [ $printOutput == 'y' ] || [ $printOutput == 'Y' ]; then sleep 3; serverCommand "tail -f ~/restic-prune-$DATE.log"; fi
		;;	
	4)
		resticCommand "snapshots"
		;;		
	5)
		resticCommand "check"
		;;	
	6)
		echo 'Enter the Restic command: '
		read RC
		resticCommand "${RC}"
		;;		
	*)
		exit
		;;
esac