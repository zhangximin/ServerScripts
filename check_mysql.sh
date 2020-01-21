#!/bin/bash

### VARIABLES ### \
EMAIL=""
SERVER=$(hostname)
MYSQL_CHECK=$(mysql --login-path=mysql_login -e "SHOW VARIABLES LIKE '%version%';" || echo 1)
STATUS_LINE=$(mysql --login-path=mysql_login -e "SHOW SLAVE STATUS\G")"1"
LAST_ERRNO=$(grep "Last_Errno" <<< "$STATUS_LINE" | awk '{ print $2 }')
SECONDS_BEHIND_MASTER=$( grep "Seconds_Behind_Master" <<< "$STATUS_LINE" | awk '{ print $2 }')
IO_IS_RUNNING=$(grep "Slave_IO_Running:" <<< "$STATUS_LINE" | awk '{ print $2 }')
SQL_IS_RUNNING=$(grep "Slave_SQL_Running:" <<< "$STATUS_LINE" | awk '{ print $2 }')
MASTER_LOG_FILE=$(grep " Master_Log_File" <<< "$STATUS_LINE" | awk '{ print $2 }')
RELAY_MASTER_LOG_FILE=$(grep "Relay_Master_Log_File" <<< "$STATUS_LINE" | awk '{ print $2 }')
ERRORS=()
SUBJECT="Errors on SQL Replication"
FILENAME=$(date +"%Y/%m/%d")
DATE=$(date +"%Y-%m-%d")
BACKUP="Backup complete"
### Run Some Checks ###

## Check if I can connect to Mysql ##
if [ "$MYSQL_CHECK" == 1 ]
then
    ERRORS=("${ERRORS[@]}" "Can't connect to MySQL (Check Pass)")
fi

## Check For Last Error ##
if [ "$LAST_ERRNO" != 0 ]
then
LAST_ERROR=$(mysql --login-path=mysql_login -e "SHOW SLAVE STATUS\G" | grep "Last_Error" | awk '{ print $2 }')
ERRORS=("${ERRORS[@]}" "Error when processing relay log (Last_Errno = $LAST_ERRNO)")
ERRORS=("${ERRORS[@]}" "(Last_Error = $LAST_ERROR)")
fi

## Check if IO thread is running ##
if [ "$IO_IS_RUNNING" != "Yes" ]
then
    ERRORS=("${ERRORS[@]}" "I/O thread for reading the master's binary log is not running (Slave_IO_Running)")
fi

## Check for SQL thread ##
if [ "$SQL_IS_RUNNING" != "Yes" ]
then
    ERRORS=("${ERRORS[@]}" "SQL thread for executing events in the relay log is not running (Slave_SQL_Running)")
fi

## Check how slow the slave is ##
if [ "$SECONDS_BEHIND_MASTER" == "NULL" ]
then
    ERRORS=("${ERRORS[@]}" "The Slave is reporting 'NULL' (Seconds_Behind_Master)")
elif [[ "$SECONDS_BEHIND_MASTER" > 60 ]]
then
    ERRORS=("${ERRORS[@]}" "The Slave is at least 60 seconds behind the master (Seconds_Behind_Master)")
fi

### Send an Email if there is an error ###
if [ "${#ERRORS[@]}" -gt 0 ]
then
    MESSAGE="An error has been detected on ${SERVER} involving the mysql replciation. Below is a list of the reported errors:\n\n
    $(for i in $(seq 0 ${#ERRORS[@]}) ; do echo "\t${ERRORS[$i]}\n" ; done)
    Please correct this ASAP
    "
/usr/sbin/ssmtp -t << EOF
to: emailaddress@email.co.uk
from: emailaddress@email.co.uk
subject: $SUBJECT
$MESSAGE
EOF
## If no error, then will do the below to grab a dump, upload it to S3 and then remove it from the local file. Follows the naming convention of the two variables $FILENAME and $DATE. 
elif [ "${#ERRORS[@]}" -le 0 ]
then
    mysqldump --login-path=mysql_login --single-transaction database_name | gzip > application.database_name.$DATE.sql.gz
    aws s3 cp application.database_name.$DATE.sql.gz s3://aws-bucket-name/$FILENAME/application.database_name.$DATE.sql.gz
    rm application.database_name.$DATE.sql.gz

/usr/sbin/ssmtp -t << EOF
to: emailaddress@email.co.uk
from: emailaddress@email.co.uk
subject: $BACKUP
Backup now complete. 
EOF

fi
