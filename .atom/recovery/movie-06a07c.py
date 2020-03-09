import nfc

print ("touch")

clf = nfc.ContactlessFrontend('usb')

while True:

    with clf:

        from nfc.clf import RemoteTarget

        target = clf.sense(RemoteTarget('106A'),RemoteTarget('106B'),RemoteTarget('212F'),iterations=3,interval=1.0)

        while target:

            tag = nfc.tag.active(clf, target)

            if tag.ndef:
                if tag.ndef.length > 0:
                    for i, record in enumerate(tag.ndef.records):
                        print(record.uri)
            # tag.sys=3
            # 
            # idm=binascii.hexlify(tag.idm)
            # 
            # print(idm.decode())

            break