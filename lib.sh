# Check that a connection to the server, either locally or remotely, exists, and set the relevant env. vars.
serverFindConnection() {
    if [ -z "$LOCALSERVERDOMAIN" ] || [ -z "$LOCALSERVERSSHPORT" ] || [ -z "$SERVERDOMAIN" ] || [ -z "$SERVERSSHPORT" ]; then
        echo "One or more required variables are missing" >&2
        exit 1
    fi
    LOCALSERVERACCESSIBLE="$(nmap $LOCALSERVERDOMAIN -PN -p $LOCALSERVERSSHPORT | grep open)"
    SERVERACCESSIBLE="$(nmap $SERVERDOMAIN -PN -p $SERVERSSHPORT | grep open)"
    TARGETDOMAIN=""
    TARGETPORT=""
    if [ ! -z "$LOCALSERVERACCESSIBLE" ]; then
        TARGETDOMAIN="$LOCALSERVERDOMAIN"
        TARGETPORT="$LOCALSERVERSSHPORT"
    elif [ ! -z "$SERVERACCESSIBLE" ]; then
        TARGETDOMAIN="$SERVERDOMAIN"
        TARGETPORT="$SERVERSSHPORT"
    else
        echo "Server is not accessible" >&2
        exit 2
    fi
}

# Ask for a restic password and store it in an env. var. if not already stored 
resticAskPass() {
    if [ -z "$RESTIC_PASSWORD" ]; then echo "Enter the backup password: " && read -s RESTIC_PASSWORD; fi
}

# Check to see if all env. vars. needed for a Restic command to run (excluding the password) exist
resticEnsureVars() {
    if [ -z "$B2_ACCOUNT_ID" ] || [ -z "$B2_ACCOUNT_KEY" ] || [ -z "$TARGETBUCKET" ] || [ -z "$REMOTEPATH" ] || [ -z "$LOCALPATH" ]; then
        echo "One or more required variables are missing" >&2
        exit 1
    fi
}

# Run Restic with the provided options if all required env. vars. exist
resticLocalCommand() {
    resticEnsureVars
    resticAskPass
    export B2_ACCOUNT_ID=$B2_ACCOUNT_ID
    export B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY
    export RESTIC_PASSWORD=$RESTIC_PASSWORD
    restic --repo b2:$TARGETBUCKET:$REMOTEPATH ${1}
}

# Run a command on the remote server if all required env. vars exist
serverCommand() {
    if [ -z "$SERVERUSERNAME" ] || [ -z "$TARGETDOMAIN" ] || [ -z "$TARGETPORT" ] || [ -z "$1" ]; then
        echo "One or more required variables are missing" >&2
        exit 1
    fi
    ssh "$SERVERUSERNAME"@"$TARGETDOMAIN" -p "$TARGETPORT" "${1}"
}

# Run Restic with the provided options on the remote server if all required env. vars. exist
resticRemoteCommand() {
    resticEnsureVars
    resticAskPass
    COMMAND="export B2_ACCOUNT_ID=$B2_ACCOUNT_ID ; export B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY ; export RESTIC_PASSWORD=$RESTIC_PASSWORD ; restic --repo b2:$TARGETBUCKET:$REMOTEPATH ${1};"
    if [ ${2} -eq 1 ]; then
        DATE="$(date +"%Y-%m-%d-%H-%M-%S")"
        COMMAND="$COMMAND > ~/restic-command-$DATE.log 2>&1"
        serverCommand "$COMMAND" &
        echo "Command is being run asynchronously on the Server, with output saved in the home directory. Attempt to print output? Y/N"
        read printOutput
        if [ $printOutput == 'y' ] || [ $printOutput == 'Y' ]; then
            sleep 3
            serverCommand "tail -f ~/restic-command-$DATE.log"
        fi
    else
        serverCommand "$COMMAND"
    fi

}
