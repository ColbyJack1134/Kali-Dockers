#!/bin/bash

# Check if the argument is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <number_of_machines>"
    exit 1
fi

number_of_machines=$1

# Pull the Kali Docker image (this can be a specific version or a custom image)
docker pull kalilinux/kali-rolling
docker build -t kali-custom .

for i in $(seq 1 $number_of_machines); do
    # Check if container already exists
    if docker ps -a --format '{{.Names}}' | grep -q "^kali${i}$"; then
        echo "Container kali${i} already exists. Skipping..."
        continue
    fi

    if id "kali${i}" &>/dev/null; then
        # Delete existing user and their home directory
        userdel -r kali${i}
    fi 

    # Create the Docker container and update to populate the command-not-found db
    docker run -d --name kali${i} --cap-add=NET_ADMIN --device /dev/net/tun kali-custom
    docker exec kali${i} apt update

    # Add the user
    useradd kali${i}

    # Generate a random 8-character hex password
    password=$(openssl rand -hex 4)
    echo "kali${i}:$password" >> ./creds

    # Set the generated password for the user
    echo "kali${i}:$password" | chpasswd

    # Create .ssh directory and rc file
    mkdir -p /home/kali${i}/.ssh
    echo "#!/bin/bash" > /home/kali${i}/.ssh/rc
    echo "exec docker exec -it kali${i} /bin/bash -c 'cd /root && tmux a || tmux'" >> /home/kali${i}/.ssh/rc
    chmod +x /home/kali${i}/.ssh/rc
    chown -R kali${i}:kali${i} /home/kali${i}

    # Restrict their shells
    chsh -s /home/kali${i}/.ssh/rc kali${i}

    # Add user to the docker group
    usermod -aG docker kali${i}
done
