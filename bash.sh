#!/bin/bash

# MySQL credentials
MYSQL_USER="your_mysql_username"
MYSQL_PASSWORD="your_mysql_password"

# Email settings
EMAIL_TO="v.vojcieskiy@gmail.com"
SMTP_SERVER="your_smtp_server"
SMTP_USER="your_smtp_username"
SMTP_PASSWORD="your_smtp_password"

# Check MySQL replication status
SLAVE_STATUS=$(mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW SLAVE STATUS\G")

# Check if replication is running
if ! echo "${SLAVE_STATUS}" | grep -q "Slave_IO_Running: Yes" || ! echo "${SLAVE_STATUS}" | grep -q "Slave_SQL_Running: Yes"; then
  # Replication is not running, send email
  echo "MySQL replication is not running" | mailx -s "MySQL replication status" -S smtp="${SMTP_SERVER}" -S smtp-user="${SMTP_USER}" -S smtp-password="${SMTP_PASSWORD}" "${EMAIL_TO}"
fi

# Check if slave is connected to master
if [ -z "$(echo "${SLAVE_STATUS}" | grep "Master_Host: " | awk '{print $2}')" ]; then
  # Slave is not connected to master, send email
  echo "MySQL replication slave is not connected to master" | mailx -s "MySQL replication status" -S smtp="${SMTP_SERVER}" -S smtp-user="${SMTP_USER}" -S smtp-password="${SMTP_PASSWORD}" "${EMAIL_TO}"
fi
