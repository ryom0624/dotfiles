# リスト型タプル

score = [40, 50]
print(score[0])
print(len(score))
score.append(60)

# 集合型
# 辞書型







# 例外処理

# 独自例外処理

# class MyException(Exception):
#     pass
# 
# 
# def div(a,b):
#     # 例外が発生しそうな対象
#     try:
#         if (b < 0):
#             raise MyException("not minus")
#         print(a/b)
#     # 例外発生時
#     except ZeroDivisionError:
#         print("not by zero")
#     except MyException as e:
#         print(e)
#     # 例外が発生しなかったとき
#     else:
#         print("no exception")
#     # 例外に関係なく行う処理
#     finally:
#         print("--end--")
# 
# # div(10,0)
# # div(10,2)
# div(10,-2)


# フォルダ分割
# import mypackage.user
# bob = mypackage.user.AdminUser("bob", 23)
# bob.say_hi()
# 
# import mypackage.user as mymodule
# bob =  mymodule.AdminUser("bob", 23)
# bob.say_hi()


# 分割
# import user # ファイル名
# bob = user.AdminUser("bob", 23)

# 特定のクラスをインポートする
# from user import AdminUser, User
# bob = AdminUser("bob", 23)
# bob.say_hi()





# 多重継承
# 
# class A:
#     def say_a(self):
#         print("A")
#     def say_hi(self):
#         print("hi from a")
# 
# class B:
#     def say_b(self):
#         print("B")
#     def say_hi(self):
#         print("hi from b")
# 
# class C(B,A):
# # class C(A,B):
#     pass
# 
# c = C()
# c.say_a()
# c.say_b()
# c.say_hi() # 同じメソッドがある場合は先に指定したほうが反映される。

# 継承
# User -> admin

# class User:
#     def __init__(self, name):
#         self.name = name
#     def say_hi(self):
#         print("hi {0}".format(self.name))
# 
# class AdminUser(User):
#     def __init__(self, name, age):
#         super().__init__(name)
#         self.age = age
#     def say_hello(self):
#         print("hello {0} ({1})".format(self.name, self.age))
#     # オーバーライド
#     def say_hi(self):
#         print("[admin] hi {0}".format(self.name))
# 
# 
# 
# bob = AdminUser("bob", 21)
# print(bob.name)
# bob.say_hi()
# bob.say_hello()

# tom = User("tom")
# tom.say_hi()

# アクセス制御
# privateは基本ない。

# メソッド
# class User:
#     count = 0
#     def __init__(self, name):
#         User.count += 1
#         # 慣習的なprivate
#         # self._name = name
#         # 厳密的なprivate
#         self.__name = name
# 
#     # インスタンスメソッド
#     def say_hi(self): # 引数にselfを渡すとクラスインスタンスの値が使える
#         print("hi {0}".format(self.__name))
#     # クラスメソッド
#     @classmethod
#     def show_info(cls):
#         print("{0} instatnces".format(cls.count))
# 
# 
# tom = User("tom")
# bob = User("bob")
# # print(tom.__name) # AttributeError: 'User' object has no attribute '__name'
# print(tom._User__name) # アクセスできちゃう。
# tom.say_hi()
# User.show_info()

# コンストラクタ

# class User:
#     # クラス変数
#     count = 0
#     def __init__(self, name): # selfはインスタンスを指す。
#         #インスタンス変数
#         User.count += 1
#         self.name = name
# 
# print(User.count)
# tom = User("tom")
# bob = User("bob")
# print(tom.name)
# print(bob.name)
# print(User.count)
# 
# print(tom.count) # 2




# クラス

# user_name = "taguchi"
# user_score = 10

# class User:
#     pass
# 
# tom = User()
# tom.name = "tom"
# tom.score = 20
# 
# bob = User()
# bob.name = "bob"
# bob.level = 5
# 
# print(tom.name)
# print(bob.level)

# 返り値（なにもないとNoneで返ってくる。）
# def say_hi():
#     pass # とりあえず何か入れておく。
#     # return "hi"
# 
# 
# msg = say_hi()
# print(msg)



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
