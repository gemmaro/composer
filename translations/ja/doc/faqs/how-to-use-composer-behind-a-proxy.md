# プロキシを隔ててComposerを使う方法

Composerは他の多くのツールと同様、環境変数を使ってプロキシサーバーの使用を制御します。
以下に対応しています。

- `http_proxy` - HTTP要求を使うプロキシ
- `https_proxy` - HTTPS要求を使うプロキシ
- `CGI_HTTP_PROXY` - HTTP要求をCLIの文脈ではないところで使うプロキシ
- `no_proxy` - プロキシを必要としないドメイン

これらの名前付き変数は慣習によるもので、公式の標準があるわけではありません。
また異なるオペレーティングシステムやツールに亙る進展や用法については複雑なものとなっています。
Composerでは小文字の名前が望ましいものの、適当な場合には大文字の名前も受け付けます。

## 使い方

ComposerはHTTPとHTTPSの要求に関して所定の環境変数を必要とします。
例えば以下です。

```
http_proxy=http://proxy.com:80
https_proxy=http://proxy.com:80
```

大文字の名前も使えます。

### CLIでない使い方

ComposerはCLIでない文脈では`http_proxy`や`HTTP_PROXY`を探しません。
このような方法で走らせている場合（例えばCMSや似たような用途に統合しているなど）、HTTP要求用に`CGI_HTTP_PROXY`を使わなければなりません。

```
CGI_HTTP_PROXY=http://proxy.com:80
https_proxy=http://proxy.com:80

# cgi_http_proxyも使えます
```

> **補足：**
> CGI_HTTP_PROXYは、要求ヘッダの操作を防ぐため、2001年にPerlで導入されました。
> この脆弱性が広く報告された2016年に一般に認知されました。
> https://httpoxy.org を参照してください。

## 構文

上の例にある通り、`scheme://host:port`を使ってください。
スキームが欠けているとhttpが既定になり、ポートが欠けているとhttpやhttpsのスキーム用に80や443の既定になりますが、その他のツールではこれらの値が必要になることがあります。

IPv4用のドットで4つに区切られた記法を使ったIPアドレスとしても、IPv6用に角括弧で囲まれた記法でも、ホストを指定できます。

### 認証

Composerは`scheme://user:pass@host:port`構文を使ったBasic認証に対応しています。
利用者名ないしパスワード中の予約されたURLの文字はパーセント符号化されていなければなりません。
例えば以下です。

```
利用者：me@company
パスワード：p@ssw$rd
プロキシ：http://proxy.com:80

# パーセント符号化された認証
me%40company:p%40ssw%24rd

scheme://me%40company:p%40ssw%24rd@proxy.com:80
```

> **補足：**
> 利用者名とパスワードの構成要素は個々にパーセント符号化され、それからコロンの区切り文字で連結しなければなりません。
> 利用者名には（パーセント符号化されたとしても）コロンを含められません。
> なぜならプロキシは最初に見付けたコロンで構成要素を分割するからです。

## HTTPSのプロキシサーバー

ComposerはHTTPSのプロキシサーバーに対応しています。
ここでのHTTPSはプロキシに接続されるために使われるスキームですが、PHP 7.3以降かつcurlのバージョン7.52.0以降のみです。

```
http_proxy=https://proxy.com:443
https_proxy=https://proxy.com:443
```

## 特定のドメインでプロキシを迂回する

`no_proxy`（または`NO_PROXY`）を使うと、プロキシが使われるべき「でない」ドメインのコンマ区切りリストが設定されます。

```
no_proxy=example.com
# example.comとそのサブドメインについてはプロキシを迂回します。

no_proxy=www.example.com
# www.example.comとそのサブドメインについてはプロキシを迂回します。
# example.comについては迂回されません。
```

ドメインは特定のポート（例えば`:80`）に制限できます。
またIPアドレスやCIDRの記法でIPアドレスのブロックとして指定することもできます。

IPv6アドレスはhttp_proxy/https_proxyの値と同様、角括弧で囲む必要はありません。
ただしこの形式は受け付けられます。

値を`*`に設定すると全ての要求に対するプロキシを迂回します。

> **補足：**
> ドメインの先頭のドットには意味がありません。
> 処理される前に取り除かれます。

## 廃止された環境変数

Composerは元々`HTTP_PROXY_REQUEST_FULLURI`及び`HTTPS_PROXY_REQUEST_FULLURI`を提供してプロキシの良くない挙動を緩和しようとしていました。
これらは必要ではなくなり、使われることもありません。
