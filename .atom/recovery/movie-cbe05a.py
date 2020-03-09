import nfc

print ("touch")

while True:

    with nfc.ContactlessFrontend("usb") as clf:
        from nfc.clf import RemoteTarget 
        target=clf.sense(RemoteTarget('106A'),RemoteTarget('106B'),RemoteTarget('212F'),iterations=3,interval=1.0)

        while target:

            tag = nfc.target.active(clf, target)
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