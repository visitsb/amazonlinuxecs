#!/bin/bash

# Start sshd daemon
/usr/bin/sudo /usr/sbin/sshd

while true
do 
  echo "Running infinitely using sleep for 60 seconds..."
  sleep 60
done

exit $?

