#!/bin/bash
# Creates a user and randomly assigns a password. The username and comment must be passed in the command line
# Informs the user if the account was not created for some reason and returns an exit status of 1
# Displays the username, password, and host where the account was created

# Make sure the script is being executed with superuser privileges.
UID_TO_TEST_FOR='0'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
	echo 'Please run with sudo or as root.'
	exit 1
fi
# Checks to make sure at least a username has been supplied
if [[ "${#}" -lt 1 ]]
then
	echo "Usage: ${0} USERNAME [COMMENT]..."
	echo 'Create an account on the local system with the name of USERNAME and a comments field of COMMENT.'
	exit 1
fi
# Uses the first argument as the username
USERNAME="${1}"
# Uses all remaining arguments on the command line as comment
shift
COMMENT="${@}"
# Generates a random password
PASSWORD=$(date +%s%N | sha256sum | head -c48)
# Create the user with the password.
useradd -c "${COMMENT}" -m "${USERNAME}"
# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'This account could not be created'
	exit 1
fi
# Set the password.
echo "${PASSWORD}" | passwd --stdin ${USERNAME}
# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'The password for the account could not be set.'
	exit 1
fi
# Force password change on first login
passwd -e ${USERNAME}
# Display the username, password, and the host where the user was created.
echo
echo 'username:'
echo "${USERNAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
