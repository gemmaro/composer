# Composerをプログラムでインストールする方法

ダウンロードページに附記したように、インストーラースクリプトにはチェックサムが含まれており、このチェックサムはインストーラのコードにより変化します。
そのため長い目で見るとこの値に依るべきではありません。

代替案はこのスクリプトを使うことです。
UNIXのユーティリティがあってのみ動作します。

```shell
#!/bin/sh

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
exit $RESULT
```

スクリプトは失敗した場合に1で、成功した場合に0で、それぞれ終了します。
また、何らエラーが起きなければ何も出ません。

別案として、そっくりそのままのインストーラーに頼りたければ、GitHubの履歴から特定のバージョンを取得できます。
GitHubのサーバーを信用できる限りにおいて、コミットハッシュは一意性と認証性を与えるに充分でしょう。
例えば以下です。

```shell
wget https://raw.githubusercontent.com/composer/getcomposer.org/f3108f64b4e1c1ce6eb462b159956461592b3e3e/web/installer -O - -q | php -- --quiet
```

コミットハッシュは https://github.com/composer/getcomposer.org/commits/main
にある何かしら最新のコミットハッシュで置き換えると良いでしょう。
