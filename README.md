# Server-Restic-Backup
Shell scripts to automate backup of a folder on a remote server to a Backblaze B2 bucket using Restic.

## Setup
Copy or rename the `vars.template.sh` file to `vars.sh`, then fill in the empty variables:
- `SERVERUSERNAME` - Username to SSH into the remote server.
- `LOCALSERVERDOMAIN` - URL of the remote server.
- `LOCALSERVERSSHPORT` - Port for the above URL.
- `SERVERDOMAIN` - Alternative URL to the server, in case the first connection fails. Could be the same as the first URL. Could technically point to a different server entirely, assuming it is setup similarly, but this is untested.
- `SERVERSSHPORT` - Port for the above URL.
- `B2_ACCOUNT_ID` - Application Key ID for a BackBlaze B2 account.
- `B2_ACCOUNT_KEY` - Application Key for the above Key ID.
- `RESTIC_PASSWORD` - Password to the encrypted Restic repo (if running for the first time, set this to the desired password). If this is empty, you will be asked for a password when running commands.
- `TARGETBUCKET` - B2 Bucket name where the Restic repo should be.
- `LOCALPATH` - Local path to the folder to be backed up.
- `REMOTEPATH` - Remote path for where the backup should be stored in the Restic repo on B2.
- `RETENTIONPOLICY` - Options to use when running `forget` the command.

## Actions
- Backup - Backs up the folder on the Server to the Restic repo on BackBlaze, according to the configuration in `vars.sh`. Creates a backup if one does not exist. Because this command takes along time to run, it is run asynchronously on the server and output is sent to a file in the server's home directory.
- Forget - Runs a `forget` command to mark certain snapshots for deletion. Uses the `RETENTIONPOLICY` from `vars.sh` to target the snapshots to be deleted.
- Prune - Runs a `prune` command to actually delete all snapshots that are marked for deletion, as well as any invalid snapshots. Because this command takes along time to run, it is run asynchronously on the server and output is sent to a file in the server's home directory.
- List Backup Snapshots - Lists all backup snapshots for the configured Restic repo on BackBlaze.
- Check Backup Integrity - Checks to see if the currently backed up snapshots are valid.
- Freeform - Allows you to run any other Restic command, such as `prune`, on the Server, using the configuration in `vars.sh`.

## Usage
Run `main.sh` and pick a command.

## TODO
- Add `restore` command.