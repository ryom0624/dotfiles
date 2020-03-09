
# 返り値（なにもないとNoneで返ってくる。）
def say_hi():
    pass # とりあえず何か入れておく。
    # return "hi"


msg = say_hi()
print(msg)



# 関数

# def say_hi(name, age = 20):
#     print("hi {0} ({1})".format(name, age))
# 
# say_hi("tom", 23)
# say_hi("bob", 21)
# say_hi("steve")
# say_hi(age=18, name="rick")



# def say_hi():
#     print("hi")
# 
# say_hi()









# For
# for i in range(0, 10):
# for i in range(10):
#     if i == 5:
#         # break
#         continue # 1回スキップ
#     print(i)
# else:
#     print("end")



# While

# i = 0
# 
# while i < 10:
#     if i == 5:
#         break
#     print(i)
#     i += 1
# else:
#     print("end")




# if

# score = int(input("score ? "))
# if score > 80:
#     print("Great")
# elif score > 60:
#     print("good")
# else:
#     print("Soso")
# 
# print("Great" if score > 80 else "Soso...")


# name = "ryo"
# score = 55.8
# print("name: %s, score: %10.2f" % (name, score))
# 
# print("name: {0}, score: {1}".format(name, score))
# print("name: {0:>10s}, score: {1:<10.2f}".format(name, score))


# データ
# 文字列
# s = "hello\n wor\tld"
# html = """<html>
# <body></body>
# </html>"""
# 
# print (s, html)

# 整数
i = 10
# 浮動小数点
f = 23.4

# 真偽値
flag = True # False


# 変数
# msg = "Hello World"
# print(msg)
# msg = "Hello Again"
# print(msg)


# 定数(慣習)
ADMIN_EMAIL = "sample@gmail.com"


# Hello World
# あってもなくても良い。
# coding: utf-8

"""
Comment
"""

# Comment
# print("hello world")
