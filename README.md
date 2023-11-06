# Kali-Dockers

# startup.sh
Usage `./startup.sh n` where `n` is the number of kali dockers you would like to create
 - builds Dockerfile, names image kali-custom
 - Creates those dockers and adds users kali1, kali2, ..., kalin
   - When connecting via ssh you will automatically be put into the docker container
 - Passwords are randomized and written to `creds`
 - If you run the script and container kali1, kali2, ..., kalim already exists, they will be skipped and kalim, ..., kalin will be created

# shutdown.sh
Usage `./shutdown.sh`
 - Shuts down all docker containers named kali*
 - Removes the users corresponding to the containers shut down
 - Deletes creds file

# install.sh
A script that is run during build, installs some basic tools
