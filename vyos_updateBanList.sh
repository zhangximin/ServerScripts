#!/bin/bash
# NOTES: Script to update IP ban list.  Run from cron, and integrate into firewall
# 
 
# variables
VERBOSE=1
DROPURL='http://www.spamhaus.org/drop/drop.txt'
EDROPURL='http://www.spamhaus.org/drop/edrop.txt'
 
# simple logger function
logger(){
  if [ "$VERBOSE" == "1" ]
  then
    echo "$@"
  fi
}
 
# set verbose flag if given
if [ "$1" == "-v" ]
then
VERBOSE=1;
fi
 
# create or truncate tmp file
>/tmp/block
 
# get drop file
wget -q $DROPURL -O - | grep ^[0-9] | sed -e 's/;.*//' >> /tmp/block
if [ $? -ne 0 ]
then
  logger "error getting drop file"
  logger "exiting..."
exit
fi
 
# get edrop file
wget -q "$EDROPURL" -O - | grep ^[0-9] | sed -e 's/;.*//' >> /tmp/block
if [ $? -ne 0 ]
then
  logger "error getting edrop file"
  logger "exiting..."
exit
fi
logger "received `wc -l /tmp/block | awk '{print $1}'` networks to block..."

#logger "starting vyatta cmd wrapper"
#/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
 
# remove existing list, in case a network has been removed"
#logger "deleting existing blocked network group"
#/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper delete firewall group network-group blocked
 
# add each network to the block list
#logger "building new blocked network group"
#logger "this might take a while..."
#for i in `cat /tmp/block`;
#do
#  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set firewall group network-group blocked network $i
#done;
 
# now commit the changes
#logger "committing changes"
#/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
 
#logger "ending vyatta cmd wrapper"
#/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end
 
# clean up
#rm -rf /tmp/block >/dev/null 2>&1
