#!/usr/bin/python3

import boto3
import json
from pygments import highlight, lexers, formatters

def jsonOut(json_msg):
    formatted_json = json.dumps(json_msg, indent=4)
    colorful_json = highlight(bytes(formatted_json, 'UTF-8'), lexers.JsonLexer(), formatters.TerminalFormatter())
    print(colorful_json)

waf_client = boto3.client('acm')

paginator = waf_client.get_paginator('list_certificates')
for response in paginator.paginate():
    for certificate in response['CertificateSummaryList']:
        print(certificate)

response = waf_client.export_certificate(
    CertificateArn='arn:aws:acm:us-east-1:674603430004:certificate/e2b98266-5f89-442d-abe7-a50c089812f0',
    Passphrase=b'Tiertime'
)

print('======================')
#jsonOut(response)
print('======================')

