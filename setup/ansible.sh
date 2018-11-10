#!/bin/bash
set -euo pipefail

########################
### SCRIPT VARIABLES ###
########################

# Internal domain name (VPN)
INTERNAL_DOMAIN_NAME="devdomain.tk"

# Name of the user to create and grant sudo privileges
## USERNAME=sammy
USERNAME=ansible

# Password of the user to create and grant sudo privileges
PASSWORD="abc123"

# Whether to copy over the root user's `authorized_keys` file to the new sudo
# user.
## COPY_AUTHORIZED_KEYS_FROM_ROOT=true
COPY_AUTHORIZED_KEYS_FROM_ROOT=false

# Specify if it's to add the user to the docker group
# ADD_USER_TO_DOCKER_GROUP=false

# Specify if the machine is an Ansible Server
ANSIBLE_SERVER=true

# Additional public keys to add to the new sudo user
# OTHER_PUBLIC_KEYS_TO_ADD=(
#	"ssh-rsa AAAAB..."
#	"ssh-rsa AAAAB..."
# )
## OTHER_PUBLIC_KEYS_TO_ADD=()
OTHER_PUBLIC_KEYS_TO_ADD=(
	#"ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjw9z+ZJuFF4nKTDMeFhtm9XIu4PYZwuRak1fgbv5dkyWH6LyZfMd6HQAqSHra6hhopNYYRclTQYNYYsVSAoATf8zu/gsb0USqi9EJ84XoOXD0x5jh0b84y/NfOEO2EEt1sKc3ysNdunLtRNI6bQBv/v/PrQD+P161KqgpXO8upjgXmpSfkWog5Nt4VcivEGdNyRQv0iVbrCyVPLjxtrhETT1WYH+v0w+04RZzkQhVQAxcjkHQ2GZFSLMFnP8ya7/yb9ddT2CcsLk1bPUIDeirwClpTs2M8BWIwrY25crvZBoK4/IA09jVvl62hOo1Gs4aBAfpHTVbvW/B+7dsdlQuw== rsa-key-20181010"
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCe7ojg0TN8BFxM/g3AHI+FUomki3SoePBHeXXXCWpqAaSBZ3XfqfKY6aZaV0axTR1grjkBy8MjuxQqCwitqNllAdrM7MskcpQz7elUmUE0rXhlSqWcp+U7vZiEnRcQzrHD2E4545B/F7RKoxTCkioSusPEA0guf6weZY3/gZm+EpqIFHYngFmYETjO3xMpSV2PvRFICzm16n1Gv+J7/sbQtRBDPoxWvY7Uszc3XV/7Yz66HYC8S76xLO3Q4HB2kebvxZ/xEuWwlFs3rMSHY0IuVz5+03MSADccyhNpvNM6D6FnIMuEu8oFJxBsVnFHF6B53KnMmtE7tYVoCxZMso7 root@main-server"
)

# SSH public key
SSH_PUBLIC="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd+PSVvCsSiE/k1IBeG1aL/l4eZKTGcgzZ9xfogI+UONcrdxymX/goaORKMQwl6W/SPAW2yg0BN+o17HkIxssTptCHpX8czfkXOW4/wW26vq7w4X9lueihnrp3IzKlYLtfPCf69uK58bKRWZuuTz8EJYuVBV73GdcM4LHoRf+3FOew+rGZwKrMBsIN63WK68+obzaBz2gTYZxJAnyzOWPIK2c+nlWHkjMHlN/3Eyy1fo08GJKNbhH83YFjc9gfEQYQiCq2wLlAaHqFOqGLsNzn2to3P4DkVaKyL6qWSIrpIuxFryd4hb94Qx4iHCghvvvc+JpF+iZlO3Tko4/Q0Gy9 ansible@dev-ubuntu-01"

# SSH private key
SSH_PRIVATE="$(cat <<- EOM
	-----BEGIN RSA PRIVATE KEY-----
	MIIEpQIBAAKCAQEA3fj0lbwrEohP5NSAXhtWi/5eHmSkxnIM2fcX6ICPlDjXK3cc
	pl/4KGjkSjEMJelv0jwFtsoNATfqNex5CMbLE6bQh6V/HM35FzluP8Ftur6u8OF/
	ZbnooZ66dyMypWC7Xzwn+vbiufGykVmbrk8/BCWLlQVe9xnXDOCx6EX/txTnsPqx
	mcCqzAbCDet1iuvPqG82gc9oE2GcSQJ8szljyCtnPp5Vh5IzB5Tf9xMstX6NPBiS
	jW4R/N2BY3PYHxEGEIgqtsC5QGh6hTqhi7Dc59raNz+A5FWisi+qlkiK6SLsRa8n
	eIW/eEMeIhwoIb773PiaRfomZTt05KOP0NBsvQIDAQABAoIBAQDbC89JaBxVOIEm
	/vECbRX2Jnl4orbcQjYebjGAtkV57rGfafay1GfOcNw/vrEPRJKds6+r1y4IMsaE
	mixClfJXHToRcibDJRuXaIw8jEQdkgiPGugeWdyQiVPXN7vF6XReIb4Occ4B0tr1
	hqkT1Y4JKIfa8ibpz+0g/ydxYIpdfoQEZUtnCzUswc5v0KsVTPwPP6yUDz9MwxFz
	ub03+ZrW3kWIqQQmdyxcWxRZL7Nowie8WqVpjIc7SqsQ6cIjInfP45t/KpWrBgEI
	hg0bEDnBVT5k4azi1XcERu0hh66bhpO5NPp5xZ7OSEO8HgN7LQ4hHE4ueOwG+3Iz
	5oJfl5j9AoGBAPXgK/PgGPbk4nBfYqCxVcz8Jy0sFf0pI4x7ncb3oeZ8jxA//uFV
	o6rNx+NZArHYoVgUqo3VRqc9eUy4kh58m8uTsPweT8CCMUm8ihjYTvtAV5l7txus
	IaA7pxz5SA6tHQ6c+tgbb92UjxvkEnWAiEowF5Nz/gG+PLHUn9ZWmXnDAoGBAOcc
	0KhjY0cEG/1o0rkL44SZCW1yeoaKXHgYLaAX7fHuU8Lsh+oHrsh+7pg1T0sEG/Ek
	pkOPznYWzfvl7PFmjrFiS0WPFFSbScZgdA80snuMwAjoNvPmr9wfi1yskSTA6Kbt
	ajz6WvUrzPxtDG07EtV7a92RI2+cyeGcpx4ECZd/AoGBAJrBEsj3lp7nJwK1dp1P
	oIJZfsr2wYxK9V35fC/8MsGgSmde8Cyhu1bJGHOm1YRcpgiLUWHeCA9BKPS6AvX/
	VgvHFJFK/sVa7GzNp1nF48hOEhS/glt/dtakVSVuXQUnvm8xLM0ST9F2LLDQVzHv
	yVhwdpZPXmN4ejkva777WLQDAoGBAKKZzmA6lNWZGYw/3MoeiDN5bH2ZZoUUAZzo
	/ei+DUYCtOHWgoVwZFNhosJp92DDAlm1vFiaa9r/jmrkyMDKtCgvDOBimx4vp0cw
	A1fTbqOoUk+x+T++lQodE3LfYrrmEomnTfCa/7Ww3GbY3j5XqpeSX0Ci5biYKh1W
	lulyU8FHAoGAZY+KJaHbAVhK4P7IBGG3Nye8mmcTtNxWplMNLtua2WGPyVh+HHqF
	Eo5UesTuLp3yOdqpkVN8DntGVHqXcZLLI2u14a5s64g+ZpNy8mbCFRwSWll0P7R2
	LTk5Br54JnlYBJXKcCZNDlrCisKtdu/Xhz0cn+9QXoqixtCCBzK7AvY=
	-----END RSA PRIVATE KEY-----
EOM
)"
# SSH_PRIVATE='-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA3fj0lbwrEohP5NSAXhtWi/5eHmSkxnIM2fcX6ICPlDjXK3cc\npl/4KGjkSjEMJelv0jwFtsoNATfqNex5CMbLE6bQh6V/HM35FzluP8Ftur6u8OF/\nZbnooZ66dyMypWC7Xzwn+vbiufGykVmbrk8/BCWLlQVe9xnXDOCx6EX/txTnsPqx\nmcCqzAbCDet1iuvPqG82gc9oE2GcSQJ8szljyCtnPp5Vh5IzB5Tf9xMstX6NPBiS\njW4R/N2BY3PYHxEGEIgqtsC5QGh6hTqhi7Dc59raNz+A5FWisi+qlkiK6SLsRa8n\neIW/eEMeIhwoIb773PiaRfomZTt05KOP0NBsvQIDAQABAoIBAQDbC89JaBxVOIEm\n/vECbRX2Jnl4orbcQjYebjGAtkV57rGfafay1GfOcNw/vrEPRJKds6+r1y4IMsaE\nmixClfJXHToRcibDJRuXaIw8jEQdkgiPGugeWdyQiVPXN7vF6XReIb4Occ4B0tr1\nhqkT1Y4JKIfa8ibpz+0g/ydxYIpdfoQEZUtnCzUswc5v0KsVTPwPP6yUDz9MwxFz\nub03+ZrW3kWIqQQmdyxcWxRZL7Nowie8WqVpjIc7SqsQ6cIjInfP45t/KpWrBgEI\nhg0bEDnBVT5k4azi1XcERu0hh66bhpO5NPp5xZ7OSEO8HgN7LQ4hHE4ueOwG+3Iz\n5oJfl5j9AoGBAPXgK/PgGPbk4nBfYqCxVcz8Jy0sFf0pI4x7ncb3oeZ8jxA//uFV\no6rNx+NZArHYoVgUqo3VRqc9eUy4kh58m8uTsPweT8CCMUm8ihjYTvtAV5l7txus\nIaA7pxz5SA6tHQ6c+tgbb92UjxvkEnWAiEowF5Nz/gG+PLHUn9ZWmXnDAoGBAOcc\n0KhjY0cEG/1o0rkL44SZCW1yeoaKXHgYLaAX7fHuU8Lsh+oHrsh+7pg1T0sEG/Ek\npkOPznYWzfvl7PFmjrFiS0WPFFSbScZgdA80snuMwAjoNvPmr9wfi1yskSTA6Kbt\najz6WvUrzPxtDG07EtV7a92RI2+cyeGcpx4ECZd/AoGBAJrBEsj3lp7nJwK1dp1P\noIJZfsr2wYxK9V35fC/8MsGgSmde8Cyhu1bJGHOm1YRcpgiLUWHeCA9BKPS6AvX/\nVgvHFJFK/sVa7GzNp1nF48hOEhS/glt/dtakVSVuXQUnvm8xLM0ST9F2LLDQVzHv\nyVhwdpZPXmN4ejkva777WLQDAoGBAKKZzmA6lNWZGYw/3MoeiDN5bH2ZZoUUAZzo\n/ei+DUYCtOHWgoVwZFNhosJp92DDAlm1vFiaa9r/jmrkyMDKtCgvDOBimx4vp0cw\nA1fTbqOoUk+x+T++lQodE3LfYrrmEomnTfCa/7Ww3GbY3j5XqpeSX0Ci5biYKh1W\nlulyU8FHAoGAZY+KJaHbAVhK4P7IBGG3Nye8mmcTtNxWplMNLtua2WGPyVh+HHqF\nEo5UesTuLp3yOdqpkVN8DntGVHqXcZLLI2u14a5s64g+ZpNy8mbCFRwSWll0P7R2\nLTk5Br54JnlYBJXKcCZNDlrCisKtdu/Xhz0cn+9QXoqixtCCBzK7AvY=\n-----END RSA PRIVATE KEY-----'

####################
### SCRIPT LOGIC ###
####################

case "$ANSIBLE_SERVER" in
	true) ANSIBLE_HOST=false ;;
	*) ANSIBLE_HOST=true ;;
esac

# Add sudo user and grant privileges
useradd --create-home --shell "/bin/bash" --groups sudo "${USERNAME}"

# Check whether the root account has a real password set
encrypted_root_pw="$(grep root /etc/shadow | cut --delimiter=: --fields=2)"

if [ -z "${PASSWORD}" ]; then
	if [ "${encrypted_root_pw}" != "*" ]; then
		# Transfer auto-generated root password to user if present
		# and lock the root account to password-based access
		echo "${USERNAME}:${encrypted_root_pw}" | chpasswd --encrypted
		passwd --lock root
	else
		# Delete invalid password for user if using keys so that a new password
		# can be set without providing a previous value
		passwd --delete "${USERNAME}"
	fi

	# Expire the sudo user's password immediately to force a change
	chage --lastday 0 "${USERNAME}"
else
	passwd --delete "${USERNAME}"
	echo "$USERNAME:$PASSWORD" | chpasswd

	echo "New password defined for $USERNAME" >> "/home/$USERNAME/setup.log"

	if [ "${encrypted_root_pw}" != "*" ]; then
		passwd --lock root
	fi
fi

# Create SSH directory for sudo user
home_directory="$(eval echo ~${USERNAME})"
mkdir --parents "${home_directory}/.ssh"

# Copy `authorized_keys` file from root if requested
if [ "${COPY_AUTHORIZED_KEYS_FROM_ROOT}" = true ]; then
	cp /root/.ssh/authorized_keys "${home_directory}/.ssh"
fi

# Add additional provided public keys
for pub_key in "${OTHER_PUBLIC_KEYS_TO_ADD[@]}"; do
	echo "${pub_key}" >> "${home_directory}/.ssh/authorized_keys"
done

# Adjust SSH configuration ownership and permissions
chmod 0700 "${home_directory}/.ssh"
chmod 0600 "${home_directory}/.ssh/authorized_keys"
chown --recursive "${USERNAME}":"${USERNAME}" "${home_directory}/.ssh"

# Disable root SSH login with password
sed --in-place 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
if sshd -t -q; then
	systemctl restart sshd
fi

# Add exception for SSH and then enable UFW firewall
ufw allow 22
ufw --force enable

apt autoremove -y

echo "Main logic finished" >> "/home/$USERNAME/setup.log"

########################
###     VPN DNS      ###
########################

echo "Defining VPN DNS..." >> "/home/$USERNAME/setup.log"

touch /etc/resolvconf/resolv.conf.d/head

{ 
	echo "search $INTERNAL_DOMAIN_NAME"
	echo "nameserver 8.8.8.8"
	echo "nameserver 8.8.4.4"
# 	echo "nameserver $NS1_IP"
# 	echo "nameserver $NS2_IP"
# 	echo "nameserver $NS3_IP"
} >> /etc/resolvconf/resolv.conf.d/head

resolvconf -u

echo "VPN DNS Defined" >> "/home/$USERNAME/setup.log"

########################
###      DOCKER      ###
########################

# if [ "${ANSIBLE_HOST}" = true ]; then
# 	echo "Installing Docker..." >> "/home/$USERNAME/setup.log"

# 	# First, update your existing list of packages
# 	apt update

# 	# Next, install a few prerequisite packages which let apt use packages over HTTPS
# 	apt install -y apt-transport-https ca-certificates curl software-properties-common

# 	# Then add the GPG key for the official Docker repository to your system
# 	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# 	# Add the Docker repository to APT sources
# 	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y

# 	# Next, update the package database with the Docker packages from the newly added repo
# 	apt update

# 	# Finally, install Docker
# 	apt install -y docker-ce

# 	# Add the user to the docker group if requested
# 	if [ "${ADD_USER_TO_DOCKER_GROUP}" = true ]; then
# 		usermod -aG docker $USERNAME
# 	fi

# 	echo "Docker Installed" >> "/home/$USERNAME/setup.log"
# fi

########################
###      ANSIBLE     ###
########################

# 1- Installing Ansible

if [ "${ANSIBLE_SERVER}" = true ]; then
	echo "Installing Ansible..." >> "/home/$USERNAME/setup.log"

	apt update
	apt install -y software-properties-common

	apt-add-repository ppa:ansible/ansible -y

	apt update

	apt install -y ansible

	mkdir "/home/$USERNAME/.tmp"
	
	echo "$SSH_PRIVATE" > "/home/$USERNAME/.ssh/id_rsa"
	echo "$SSH_PUBLIC" > "/home/$USERNAME/.ssh/id_rsa.pub"

	chmod 600 "/home/$USERNAME/.ssh/id_rsa"
	chmod 644 "/home/$USERNAME/.ssh/id_rsa.pub"

	chown --recursive "${USERNAME}":"${USERNAME}" "/home/$USERNAME/.ssh"
	
	echo "Ansible Installed" >> "/home/$USERNAME/setup.log"
fi

# 2- Configuring SSH Access to the Ansible Hosts

if [ "${ANSIBLE_HOST}" = true ]; then
	echo "Preparing Ansible Host..." >> "/home/$USERNAME/setup.log"
	
	apt update
	apt install -y python
	
	echo "Ansible Host Prepared" >> "/home/$USERNAME/setup.log"
fi

########################
###    KUBERNETES    ###
########################
	
echo "Setup Finished" >> "/home/$USERNAME/setup.log"
