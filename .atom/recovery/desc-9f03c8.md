 データ構造
 - メモリ内に保持
 実行中のアプリケーション自体に保持する。
 配列、スライス、マップ、構造体
 
 - ファイルシステム上のファイル
 大量のデータをもらうときにcsvとかだと楽なのでそうするときも多い。
 データのやり取りをするのに[]byteを使う。
 書き込み -- ioutil.Write(ファイル名,データ,パーミッション)
 読み込み -- ioutil.ReadFile(ファイル名)

 gob -- バイナリデータのストリーム管理。
 
 - データベース内
 堅牢さやスケーラビリティを求める場合にデータベースを用いる。
   
 - psgl
 
```
yum -y localinstall https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm




```