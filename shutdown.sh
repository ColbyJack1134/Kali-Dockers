#!/bin/bash

# Fetch all containers with the name pattern "kali*"
containers=$(docker ps -a -q --filter "name=kali")

# Stop and remove the containers
if [[ ! -z "$containers" ]]; then
    docker stop $containers
    docker rm $containers
fi

# Remove the corresponding users
for user in $(getent passwd | grep kali[0-9]+ | cut -d: -f1); do
    # Kill all processes for the user
    pkill -u $user
    
    # Give it a moment to let processes terminate
    sleep 2
    
    userdel $user || {
        echo "Failed to delete user: $user. Attempting to forcibly remove home directory."
        rm -rf /home/$user
    }
done

echo "Deleting creds file"
rm ./creds

echo "All Kali containers and users have been removed."
