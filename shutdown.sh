#!/bin/bash
#
# /usr/sbin/shutdown.sh
#
# Deletes this host's CNAME record from route53
# 
# Author: Tyler Stroud <tyler@tylerstroud.com>

# BEGIN CONFIGURATION
HOSTED_ZONE_ID=
DOMAIN=
TTL=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
PUPPETMASTER=
# END CONFIGURATION

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

ROUTE53=/usr/bin/route53
LOGGER=/usr/bin/logger
CURL=/usr/bin/curl

ec2_public_hostname=`$CURL -fs http://169.254.169.254/latest/meta-data/public-hostname`
hostname=$(hostname)

$LOGGER "Deactivating node on the puppet master"
puppetmaster_command_url=https://$PUPPETMASTER:8081/v2/commands
cert=/var/lib/puppet/ssl/certs/$hostname.pem
key=/var/lib/puppet/ssl/private_keys/$hostname.pem
ca=/var/lib/puppet/ssl/certs/ca.pem

$CURL -H 'Accept: application/json' $puppetmaster_command_url --cert $cert --cacert $ca --key $key --data-urlencode 'payload={"command":"deactivate node","version": 1,"payload":"\"'$hostname'\""}'

$LOGGER "Deleting certificate for $hostname"
$CURL -k -X DELETE -H "Accept: pson" https://$PUPPETMASTER:8140/production/certificate_status/$hostname > /tmp/delete-cert 2>&1

$LOGGER "Deleting CNAME record for $hostname"
$ROUTE53 del_record $HOSTED_ZONE_ID $hostname CNAME $ec2_public_hostname $TTL > /tmp/delete-route53-cname.out 2>&1
