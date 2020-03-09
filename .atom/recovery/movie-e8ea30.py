import nfc
from nfc.clf import RemoteTarget

print ("touch")


while True:

    with nfc.ContactlessFrontend('usb') as clf:

        target = clf.sense(RemoteTarget('106A'), RemoteTarget('106B'), RemoteTarget('212F'),iterations=3,interval=1.0)

        while target:

            tag = nfc.tag.activate(clf,target)

            if tag.ndef:
                print(tag.ndef.records[0].uri)
            else:
                print(;hello')
            break