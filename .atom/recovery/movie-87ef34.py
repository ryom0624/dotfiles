import nfc

print ("touch")

clf = nfc.ContactlessFrontend('usb')
from nfc.clf import RemoteTarget
target = clf.sense(RemoteTarget('106A'), RemoteTarget('106B'), RemoteTarget('212F'),iterations=3,interval=1.0)

while True:

    while target:

        tag = nfc.tag.activate(clf,target)

        with tag:
            if tag.ndef:
                print(tag.ndef.records[0].uri)

        break