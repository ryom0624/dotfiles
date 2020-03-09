# import nfc
# from nfc.clf import RemoteTarget

from selenium import webdriver
# from selenium.webdriver.common.keys import Keys
# from selenium.webdriver.common.by import By
# from selenium.webdriver.support.ui import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
from time import sleep
from selenium.webdriver.chrome.options import Options


# print ("Please Touch")

chromeOptions = Options()
chromeOptions.add_argument("--kiosk")
chromeOptions.add_argument("--disable-infobars")
chromeOptions.add_experimental_argument("--disable-infobars")
driver = webdriver.Chrome(options=chromeOptions)
driver.get("file:///Users/two_0002/Desktop/two_brands_film.mp4")
sleep(2)
driver.close()


# while True:
# 
#     with nfc.ContactlessFrontend('usb') as clf:
# 
#         target = clf.sense(RemoteTarget('106A'), RemoteTarget('106B'), RemoteTarget('212F'))
# 
#         while target:
# 
#             tag = nfc.tag.activate(clf,target)
#             # driver.get(tag.ndef.records[0].uri)
# 
#             try:
#                 print(tag.ndef.records[0].uri)
#             except:
#                 print('Released')
#                 # driver.close()
# 
#             break