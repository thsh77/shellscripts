#!/bin/bash

# Script to backup personal files to an external USB drive.
# Specify mount point here (DO NOT end mount_point with a forward
# slash.
# To restore from backup
# cp --archive /media/th/Backup3/home/th/. /home/th/

# Define a mountpoint
mount_point="/media/th/Backup3"

echo "######"
echo ""

# Check whether target volume is mounted, and mount if not.
if ! mountpoint -q ${mount_point}/; then
  echo "Mounting external USB drive."
  echo "Mountpoint is ${mount_point}."
  if ! mount ${mount_point}; then
    echo "An error code was returned by mount command!"
    exit 5
  else echo "Mounted successfully.";
  fi
else echo "${mount_point} is already mounted.";
fi

# Target volume MUST be mounted at this point. If not, die screaming.
if ! mountpoint -q ${mount_point}/; then
  echo "Mounting failed! Cannot run backup without backup volume!"
  exit 1
fi

echo "Preparing to transfer differences using rsync."

# Use the year to create a new backup directory each year.
current_year=`date +%Y`
# Now construct the backup path, specifying the mount point followed
# byt the path to our backup directory, finishing with the current
# year. DO NOT end backup_path with a forward slash.
backup_path=${mount_point}'/rsync-backup/'${current_year}

echo "Backup storage directory path is ${backup_path}"
echo "Starting backup of /home/th ..."

# Create the target directoy if it does not already exist.
mkdir --parents ${backup_path}/home/th/

# Use rsync to do the backup, and pipe output to the tee command, so
# it gets saved to file AND output to screen.
# Note that the 2>&1 part simply instructs errors to be sent to
# standard output so that we see them in our output file.
sudo rsync --archive --verbose --human-readable --itemize-changes \
  --progress --delete --delete-excluded \
  --exclude='.local/share/Trash/' \
  /home/th ${backup_path}/home/th/ 2>&1 | tee /home/th/rsync-output.txt

# Ask user whether target volume should be unmounted.
echo -n "Do you want to unmount ${mount_point} (no)"
read -p ": " unmount_answer
unmount_answer=${unmount_answer,,}  # make lowercase
if [ "$unmount_answer" == "y" ] || [ "$unmount_answer" == "yes" ]; then
	if ! umount ${mount_point}; then
		echo "An error code was returned by umount command!"
		exit 5
	else echo "Dismounted successfully.";
	fi
else echo "Volume remains mounted.";
fi

echo ""
echo "######"
