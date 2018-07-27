#!/bin/bash
# Prompts the user to create a user with a username, name of the person using the account, and the initial password for the account
# Informs the user if the account was not created for some reason and returns an exit status of 1
# Displays the username, password, and host where the account was created

# Make sure the script is being executed with superuser privileges.
UID_TO_TEST_FOR='0'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
	echo 'Please run with sudo or as root.'
	exit 1
fi
# Get the username (login).
read -p 'Enter the username to create: ' USERNAME
# Get the real name (contents for the description field).
read -p 'Enter the name of the person or the application that will be using this account: ' COMMENT
# Get the password.
read -p 'Enter the password to use for the account: ' PASSWORD
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
