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
yum info postgresql10-server
yum -y install postgresql10-server
/usr/pgsql-10/bin/postgres --version
/usr/pgsql-10/bin/postgresql-10-setup initdb
systemctl enable postgresql-10
systemctl start postgresql-10

// peer認証を切る。peer -> trust
vi /var/lib/pgsql/10/data/pg_hba.conf
//全部これにする。
host all all  trust

systemctl restart postgresql-10

su - postgres
-bash-4.2$ createuser --interactive
-bash-4.2$ createdb root
// rootに戻る
# createuser -P -d gwp
# createdb gwp
# psql
root=# ALTER DATABASE gwp OWNER TO gwp;ß
# psql -U gwp -f setup.sql -d gwp
```

構造体sql.DBはデータベースへのハンドルで、sqlパッケージが維持管理する0個以上のデータベース接続のプールを表す。

Open()は構造体sql.DBへのポインタを返す。
`*Db: {0 {user=gwp dbname=gwp password=gwp sslmode=disable 0x86b8b8} 0 {0 0} [] map[] 0 0 0xc000020120 0xc000058180 false map[] map[] 0 0 0 <nil> 0 0 0 0x4be0e0}`

実際の接続でないのでクローズの必要なし。
接続に必要な構造体を設定するだけ。

Go言語は公式のデータベースドライバを公開していないが、
すべてのデータベースライブラリはsql.driverパッケージ内のインターフェースに準拠している。
インポートするときは_で指定する、直接使用するのではなく、sqlパッケージから使用するという意味。

構造体Postのメソッドとしてcreate関数を用意。
ステートメントを繰り返し使うときにpreparedステートメントを利用する。
sql.Stmtはsql.Driverのパッケージ内で定義されていて、構造体はデータベースドライバによって実装されている。

QueryRowは構造体sql.Rowへの参照を1つだけ返したい。
Scanわけわからn。
