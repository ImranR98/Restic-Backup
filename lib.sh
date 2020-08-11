serverFindConnection() {
    if [ -z "$LOCALSERVERDOMAIN" ] || [ -z "$LOCALSERVERSSHPORT" ] || [ -z "$SERVERDOMAIN" ] || [ -z "$SERVERSSHPORT" ]; then echo "One or more required variables are missing" >&2; exit 1; fi
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

serverCommand() {
    if [ -z "$SERVERUSERNAME" ] || [ -z "$TARGETDOMAIN" ] || [ -z "$TARGETPORT" ] || [ -z "$1" ]; then echo "One or more required variables are missing" >&2; exit 1; fi
    ssh "$SERVERUSERNAME"@"$TARGETDOMAIN" -p "$TARGETPORT" "${1}"
}

resticCommand() {
    if [ -z "$B2_ACCOUNT_ID" ] || [ -z "$B2_ACCOUNT_KEY" ] || [ -z "$TARGETBUCKET" ] || [ -z "$REMOTEPATH" ] || [ -z "$LOCALPATH" ]; then echo "One or more required variables are missing" >&2; exit 1; fi
    if [ -z "$RESTIC_PASSWORD" ]; then echo "Enter the backup password: " && read -s RESTIC_PASSWORD; fi
    serverCommand "export B2_ACCOUNT_ID=$B2_ACCOUNT_ID ; export B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY ; export RESTIC_PASSWORD=$RESTIC_PASSWORD ; restic --repo b2:$TARGETBUCKET:$REMOTEPATH ${1};"
}