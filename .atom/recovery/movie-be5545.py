import nfc

print ("touch")


while True:

    with nfc.ContactlessFrontend('usb') as clf:

    from nfc.clf import RemoteTarget
    target = clf.sense(RemoteTarget('106A'), RemoteTarget('106B'), RemoteTarget('212F'),iterations=3,interval=1.0)


    while target:
        print('hello')
        
        # tag = nfc.tag.activate(clf,target)
        # if tag.ndef:
        #     print(tag.ndef.records[0].uri)

        break