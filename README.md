# Restic-Backup
Shell scripts to automate backup of a folder to a Backblaze B2 bucket or another local folder using Restic.

## Environment Variables
Copy or rename the `vars.template.sh` file to `vars.sh`, then fill in the empty variables:

- `B2_ACCOUNT_ID` - Application Key ID for a BackBlaze B2 account.
- `B2_ACCOUNT_KEY` - Application Key for the above Key ID.
- `RESTIC_PASSWORD` - Password to the encrypted Restic repo (if running for the first time, set this to the desired password). If this is empty, you will be asked for a password when running commands.
- `TARGETBUCKET` - B2 Bucket name where the Restic repo should be. If this is left empty, the Restic repo is assumed to be a local folder at `REMOTEPATH`.
- `LOCALPATH` - Path to the local folder to be backed up.
- `REMOTEPATH` - Remote path for where the backup should be stored in the Restic repo on B2.
- `RETENTIONPOLICY` - Options to use when running `forget` the command.

You can place `vars.sh` at an alternative path and provide it as the first argument to the script.

## Actions
- Backup - Backs up the folder to the Restic repo on BackBlaze, according to the configuration in `vars.sh`. Creates a backup if one does not exist, else updates the existing backup.
- Forget - Runs a `forget` command to mark certain snapshots for deletion. Uses the `RETENTIONPOLICY` from `vars.sh` to target the snapshots to be deleted.
- Prune - Runs a `prune` command to actually delete all snapshots that are marked for deletion, as well as any invalid snapshots.
- List Backup Snapshots - Lists all backup snapshots for the configured Restic repo on BackBlaze.
- Check Backup Integrity - Checks to see if the currently backed up snapshots are valid.
- Mount - Mounts the repo to ~/resticBackup. This can be used to restore data.
- Freeform - Allows you to run any other Restic command, such as `prune`, using the configuration in `vars.sh`.

## Usage
Run `main.sh` and pick a command.