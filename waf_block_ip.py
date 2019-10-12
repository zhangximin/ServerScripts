#!/usr/bin/python3

import boto3
import json
from pygments import highlight, lexers, formatters

def jsonOut(json_msg):
    formatted_json = json.dumps(json_msg, indent=4)
    colorful_json = highlight(bytes(formatted_json, 'UTF-8'), lexers.JsonLexer(), formatters.TerminalFormatter())
    print(colorful_json)

waf_client = boto3.client('waf')

def print_ip_sets():
    global waf_client
    response = waf_client.list_ip_sets(
        Limit=100,
    )

    print('WAF IP Sets:')
    print('======================')
    jsonOut(response)
    print('======================')

    print("IPSet --")
    for ipset in response['IPSets']:
        print(" {0}: {1}".format(ipset['Name'], ipset['IPSetId']))

    ips = waf_client.get_ip_set(
        IPSetId=ipset['IPSetId']
    )

    jsonOut(ips)

def delete_all_ips(ipsetid):
    global waf_client
    res = waf_client.get_ip_set(
        IPSetId=ipsetid
    )
    for oIp in res['IPSet']['IPSetDescriptors']:
      if oIp['Value'] != '220.243.135.0/24' and oIp['Value'] != '220.243.136.0/24' :
        print('Deleting {0}'.format(oIp['Value']))
        rToken = waf_client.get_change_token()
        waf_client.update_ip_set(
            IPSetId=ipsetid,
            ChangeToken=rToken['ChangeToken'],
            Updates=[
                {
                    'Action': 'DELETE',
                    'IPSetDescriptor': {
                        'Type': oIp['Type'],
                        'Value': oIp['Value']
                    }
                },
            ]
        )

def add_ip(ip, ipsetid):
    print('adding ip: {0}'.format(ip))
    global waf_client
    rToken = waf_client.get_change_token()
    waf_client.update_ip_set(
        IPSetId=ipsetid,
        ChangeToken=rToken['ChangeToken'],
        Updates=[
            {
                'Action': 'INSERT',
                'IPSetDescriptor': {
                    'Type': 'IPV4' if len(ip) > 15 else 'IPV6',
                    'Value': ip
                }
            },
        ]
    )

# delete_all_ips('9ddc98b1-d742-4422-8941-8461894706d0')
# add_ip('94.103.120.10/32', '9ddc98b1-d742-4422-8941-8461894706d0')
# add_ip('94.103.120.10/32', '9ddc98b1-d742-4422-8941-8461894706d0')
# add_ip('49.235.83.106/32', '9ddc98b1-d742-4422-8941-8461894706d0')

# Readline from file and sorted for distinct.
with open('ips.log') as f:
    lines = sorted(set(line.rstrip('\n').lower() for line in f))

for line in lines:
    print('Remove # at the head of next line, add {0} to firewall!'.format(line))
#    add_ip(line, '9ddc98b1-d742-4422-8941-8461894706d0')

print('')
print('============')
print('All Done!')
