#!/usr/bin/env python3

import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
from simple_salesforce import Salesforce
import os
from time import sleep

reader = SimpleMFRC522()

try:
    sf=Salesforce(instance_url=os.getenv('SFURL'), session_id=os.getenv('SID'))
    while True:
        option = int(input('1. write\n2. read\n'))
        if option == 1:
            sku = input('Enter SKU: ')
            reader.write(sku)
            print('SKU assigned')
        else:
            id, sku = reader.read()
            print('Tag read')
            print(id)
            print(sku)
            event = sf.RFIDReading__e.create({'TagId__c':id,'SKU__c':sku.strip()})
            print('Event sent')
            print(event)
        sleep(2)
except KeyboardInterrupt:
    GPIO.cleanup()
