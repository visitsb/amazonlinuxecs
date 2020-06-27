#!/bin/bash

/bin/echo "Starting SSH daemon..."
/usr/bin/sudo /usr/sbin/sshd
/bin/echo "Starting GOSS health checks..."
/bin/sh -c "cd / ; /usr/bin/sudo /usr/local/bin/goss serve --format json --cache 5s --listen-addr 0.0.0.0:8080 --endpoint /healthz " 1> /dev/null 2>&1 &

########### SIGINT handler ############
function _int() {
  /bin/echo "Stopping SSH daemon..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/sbin/sshd

  /bin/echo "Stopping GOSS health checks..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/local/bin/goss

  /bin/echo "Waking up from sleep..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/bin/sleep
}

########### SIGTERM handler ############
function _term() {
  /bin/echo "Stopping SSH daemon..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/sbin/sshd

  /bin/echo "Stopping GOSS health checks..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/local/bin/goss

  /bin/echo "Waking up from sleep..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/bin/sleep
}

########### SIGKILL handler ############
function _kill() {
  /bin/echo "Stopping SSH daemon..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/sbin/sshd

  /bin/echo "Stopping GOSS health checks..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/local/bin/goss

  /bin/echo "Waking up from sleep..."
  /usr/bin/sudo /usr/bin/pkill --full /usr/bin/sleep
}

# Set SIGINT handler
trap _int SIGINT
# Set SIGTERM handler
trap _term SIGTERM
# Set SIGKILL handler
trap _kill SIGKILL

while true
do
  /bin/echo "Going to sleep for 60 seconds. Zzz..."
  /usr/bin/sleep 60s
  if [ ${?} -ne 0 ]; then
    /bin/echo "Did someone wake me up?"
    break
  fi;
done

/bin/echo "Shutting down..."
exit ${?}
