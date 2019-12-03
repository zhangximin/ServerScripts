#!/usr/bin/python3

import requests
import boto3
import json
from pygments import highlight, lexers, formatters

def get_bad_ip_list():
    url = "https://api.abuseipdb.com/api/v2/blacklist"
    queryString = {
        "confidenceMinimum": "45"
    }
    headers = {
        "Key": "50902e8530129b77bdb02573dc138e5073e367d48939251d415418658e7886c2a974dba66a685ccb",
        "Accept": "application/json"
    }
    res = requests.request(method="GET", url=url, headers=headers, params=queryString)
#    print_response(res)
    return json.loads(res.text)

def jsonOut(json_msg):
    formatted_json = json.dumps(json_msg, indent=4)
    colorful_json = highlight(bytes(formatted_json, 'UTF-8'), lexers.JsonLexer(), formatters.TerminalFormatter())
    print(colorful_json)

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
    try:
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
    except:
        print('adding ip: {0} error!'.format(ip))

# Print out request and response items.
def print_request(req):
    print('HTTP/1.1 {method} {url}\n{headers}\n\n{body}'.format(
        method=req.method,
        url=req.url,
        headers='\n'.join('{}: {}'.format(k, v) for k, v in req.headers.items()),
        body=req.body,
    ))

def print_response(res):
    print('HTTP/1.1 {status_code}\n{headers}\n\n{body}'.format(
        status_code=res.status_code,
        headers='\n'.join('{}: {}'.format(k, v) for k, v in res.headers.items()),
        body=res.content,
    ))

whiteList = {'119.61.27.34',
            '119.61.27.35',
            '124.207.116.1', '124.207.116.4', '124.207.116.10', 
            '13.57.224.2'
            }

waf_client = boto3.client('waf')
#delete_all_ips('9ddc98b1-d742-4422-8941-8461894706d0')
# add_ip('94.103.120.10/32', '9ddc98b1-d742-4422-8941-8461894706d0')
# add_ip('49.235.83.106/32', '9ddc98b1-d742-4422-8941-8461894706d0')

# add for Huawei Cloud.
add_ip('114.119.128.0/19', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('114.119.160.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('119.8.0.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('119.8.32.0/19', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.0.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.112.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.125.0/24', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.128.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.144.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.144.0/24', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.152.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.160.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.16.0/22', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.176.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.182.0/23', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.192.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.20.0/22', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.208.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.224.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.240.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.24.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.32.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.48.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.64.0/21', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.67.0/24', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.76.0/24', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.77.0/24', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.79.0/24 ', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.80.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')
add_ip('159.138.96.0/20', '9ddc98b1-d742-4422-8941-8461894706d0')


# Readline from file and sorted for distinct.
#with open('ips.bad') as f:
#    lines = sorted(set(line.rstrip('\n').lower() for line in f))

#for line in lines:
#    print('Remove # at the head of next line, add {0} to firewall!'.format(line))
#    add_ip(line, '9ddc98b1-d742-4422-8941-8461894706d0')

#resp_data = get_bad_ip_list()
#if "data" in resp_data:
#    for badIp in resp_data["data"]:
#        if badIp["ipAddress"] not in whiteList:
#            add_ip(badIp["ipAddress"] + "/32", '9ddc98b1-d742-4422-8941-8461894706d0')
#else:
#    jsonOut(resp_data)

print('')
print('============')
print('All Done!')
