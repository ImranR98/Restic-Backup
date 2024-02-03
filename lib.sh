# Ask for a restic password and store it in an env. var. if not already stored
resticAskPass() {
    if [ -z "$RESTIC_PASSWORD" ]; then echo "Enter the backup password: " && read -s RESTIC_PASSWORD; fi
}

# Check to see if all env. vars. needed for a Restic command to run (excluding the password) exist
resticEnsureVars() {
    if [ -z "$REMOTEPATH" ] || [ -z "$LOCALPATH" ]; then
        echo "One or more required variables are missing" >&2
        exit 1
    fi
    if [ -n "$TARGETBUCKET" ]; then
        if [ -z "$B2_ACCOUNT_ID" ] || [ -z "$B2_ACCOUNT_KEY" ]; then
            echo "One or more required variables are missing" >&2
            exit 1
        fi
    fi
}

# Run Restic with the provided options if all required env. vars. exist
resticLocalCommand() {
    resticEnsureVars
    resticAskPass
    export B2_ACCOUNT_ID=$B2_ACCOUNT_ID
    export B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY
    export RESTIC_PASSWORD=$RESTIC_PASSWORD
    repo="$REMOTEPATH"
    if [ -n "$TARGETBUCKET" ]; then
        repo="b2:$TARGETBUCKET:$REMOTEPATH"
    fi
    restic --repo "$repo" ${1}
}