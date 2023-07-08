# 構成

本章では`composer.json`の[スキーマ](04-schema.md)の`config`節について記述していきます。

## process-timeout

プロセス実行の制限時間（秒）です。
既定では300（5分）です。
gitのクローンのような時間の掛かるプロセスは、Composerによりプロセスが異常終了したと推定される前に実行できます。
接続が遅い場合やベンダーが大きい場合は、これを高くする必要があるかもしれません。

`scripts`以下の独自コマンドでプロセスの制限時間を無効にするには、静的ヘルパーが使えます。

```json
{
    "scripts": {
        "test": [
            "Composer\\Config::disableProcessTimeout",
            "phpunit"
        ]
    }
}
```

## allow-plugins

既定は`{}`で、1つもプラグインを読み込むことはできません。

Composer
2.2.0では、`allow-plugins`オプションによってセキュリティの層が追加され、Composerの実行中にどのComposerプラグインがコードを実行できるかを制限できるようになりました。

新しいプラグインが最初に活性化され、それが構成オプションにまだ挙げられていなければ、Composerは警告を印字します。
Composerを対話的に実行すると、プラグインを実行するかどうかを決めるようプロンプトを出します。

この設定を使うと、信頼できるパッケージのみがコードを実行できるようになります。
パッケージ名パターンをキーに持つオブジェクトに設定します。
値は、許可する場合は**true**で、許可しない場合は**false**です。
いずれもこれ以外の警告とプロンプトは抑制されます。

```json
{
    "config": {
        "allow-plugins": {
            "third-party/required-plugin": true,
            "my-organization/*": true,
            "unnecessary/plugin": false
        }
    }
}
```

構成オプション自体を`false`にして全てのプラグインを拒否したり、`true`にして全てのプロラグインが走るのを許可したり（全くお勧めしません）するように設定することもできます。
例えば以下の通りです。

```json
{
    "config": {
        "allow-plugins": false
    }
}
```

## use-include-path

既定では`false`です。
`true`にするとComposerの自動読み込み器はPHPのインクルードパスにあるクラスも探します。

## preferred-install

既定では`dist`で、`source`、`dist`、`auto`の何れかです。
このオプションではComposerが優先して使うインストール方法を設定できます。
オプションで、より柔軟なインストール設定のためにキーにパッケージ名のパターンがあるオブジェクトにすることもできます。

```json
{
    "config": {
        "preferred-install": {
            "my-organization/stable-package": "dist",
            "my-organization/*": "source",
            "partner-organization/*": "auto",
            "*": "dist"
        }
    }
}
```

- `source`は、Composerが（存在する場合）`source`からパッケージをインストールすることを意味します。
  通常、git cloneまたは同等のパッケージが使用するバージョン管理システムのチェックアウトです。
  プロジェクトにバグ修正を行い、依存関係のローカルgitクローンを直接取得する場合に便利です。
- `auto`は遺物的な挙動です。
  開発バージョンの場合にComposerは`source`を自動的に使用し、それ以外の場合は`dist`を使用します。
- `dist`（Composer 2.1以降では既定）は、可能であればComposerが`dist`からインストールすることを意味します。
  通常、これはzipファイルのダウンロードであり、リポジトリ全体のクローンよりも高速です。

> **補足：** 順番は重要です。
> より限定されたパターンは、より緩いパターンの前に来るべきです。
> 大域構成やパッケージ構成で文字列表記とハッシュ構成を混在させると、文字列表記は`*`パッケージパターンに解釈されます。

## audit

セキュリティ監査の構成オプション

### ignore

勧告の識別子、リモートの識別子、CVEの識別子のリストです。
報告はされますが監査コマンドは通過させます。

```json
{
    "config": {
        "audit": {
            "ignore": {
                "CVE-1234": "The affected component is not in use.",
                "GHSA-xx": "The security fix was applied as a patch.",
                "PKSA-yy": "Due to mitigations in place the update can be delayed."
            }
        }
    }
}
```

もしくは以下です。

```json
{
    "config": {
        "audit": {
            "ignore": ["CVE-1234", "GHSA-xx", "PKSA-yy"]
        }
    }
}
```

### abandoned

Composer 2.6では`report`が既定値であり、Composer 2.7以降では`fail`が既定値です。
監査コマンドが放棄されたパッケージを報告するかどうかを定義するもので、3つの値を取り得ます。

- `ignore`は監査コマンドは放棄されたパッケージを全く考慮しないという意味です。
- `report`は放棄されたパッケージがエラーとして報告されるものの、非ゼロコードでコマンドが終了してしまわないようにする意味です。
- `fail`は監査が放棄されたパッケージにより非ゼロコードで失敗するようになる意味です。

## use-parent-dir

composer.jsonがないディレクトリでComposerを実行しており、その上のディレクトリにcomposer.jsonがある場合、Composerは既定でそのディレクトリのcomposer.jsonを代わりに使用するかどうかを尋ねます。

このプロンプトに対して常に「はい」と答えたい場合は、この構成値を`true`に設定できます。
プロンプトが表示されないようにするには、`false`に設定します。
既定は`"prompt"`です。

> **補足：** この構成を機能させるには、大域的な利用者全体の構成で設定しなければなりません。
> 例えば`php composer.phar config --global use-parent-dir true`を使用して設定します。

## store-auths

認証のプロンプトの後にする動作です。
`true`（常に保存する）、`false`（保存しない）、`"prompt"`（毎回確認する）のいずれか1つで、既定では`"prompt"`です。

## github-protocols

既定では`["https", "ssh", "git"]`です。
github.comからクローンを作成するときに使用するプロトコルのリストで、優先度順に並べます。
既定では`git`が存在しますが、gitプロトコルは暗号化されていないため、[secure-http](#secure-http)が無効になっている場合のみ使われます。
originのリモートプッシュURLでssh (`git@github.com:...`)
ではなくhttpsを使用する場合、プロトコルリストを`["https"]`のみに設定すると、ComposerはプッシュURLをSSHのURLに上書きすることを取り止めます。

## github-oauth

ドメイン名とoauthキーのリストです。
たとえば、このオプションの値として`{"github.com":
"oauthtoken"}`を使用すると、`oauthtoken`を使用してgithubのプライベートリポジトリにアクセスし、APIのIPに基づく低いレート制限を回避します。
Composerは、必要に応じて資格情報を要求する場合がありますが、これらは手動で設定することもできます。
GitHubのOAuthトークンを取得する方法およびcliの構文の詳細については、[こちら](articles/authentication-for-private-packages.md#github-oauth)を参照してください。

## gitlab-domains

既定では`["gitlab.com"]`です。
GitLabサーバーのドメインのリストです。
`gitlab`リポジトリ種別を使う場合に使用されます。

## gitlab-oauth

ドメイン名とoauthキーのリストです。
たとえば、このオプションの値として`{"gitlab.com":
"oauthtoken"}`を使用すると、`oauthtoken`を使用してgitlabのプライベートリポジトリにアクセスします。
なお、パッケージがgitlab.comでホストされていない場合、ドメイン名も[`gitlab-domains`](06-config.md#gitlab-domains)オプションで指定する必要があります。
詳細情報は[こちら](articles/authentication-for-private-packages.md#gitlab-oauth)にもあります。

## gitlab-token

ドメイン名とプライベートトークンのリストです。
プライベートトークンは、単純な文字列、またはユーザー名とトークンを含む配列のいずれかです。
たとえば、このオプションの値として`{"gitlab.com": "privatetoken"}`を使用すると、`privatetoken`を使用してgitlabのプライベートリポジトリにアクセスします。
`{"gitlab.com": {"username": "gitlabuser", "token": "privatetoken"}}`を使用すると、ユーザー名とトークンの両方を使ってgitlabのデプロイトークン機能 (https://docs.gitlab.com/ ee/user/project/deploy_tokens/) を使用します。
なお、パッケージがgitlab.comでホストされていない場合、ドメイン名も[`gitlab-domains`](06-config.md#gitlab-domains)オプションで指定する必要があります。
トークンには`api`または`read_api`スコープが必要です。
詳細情報は[こちら](articles/authentication-for-private-packages.md#gitlab-token)にもあります。

## gitlab-protocol

パッケージメタデータの`source`値用にリポジトリのURLを作成するときに強制的に使用するプロトコルです。
`git`または`http`のいずれかです（`https`は`http`の同義語として扱われます）。
HTTPベーシック認証を使った[GitLabのCI_JOB_TOKEN](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-reference)で後々GitLab
CIのジョブでクローンされるプライベートリポジトリを参照するプロジェクトを扱う際に役立ちます。
既定では、Composerはプライベートリポジトリについてはgit-over-SSHのURLを生成し、パブリックなリポジトリについてはHTTP(S)のみを生成します。

## disable-tls

既定は`false`です。
真に設定すると、すべてのHTTPSのURLが代わりにHTTPで試行され、ネットワークレベルの暗号化は実行されません。
これを有効にすることはセキュリティリスクであり、全く推奨されません。
より良い方法は、php.iniでphp_openssl拡張機能を有効にすることです。
これを有効にすると、`secure-http`オプションが暗黙に無効になります。

## secure-http

既定では`true`です。
真に設定すると、HTTPSのURLのみがComposer経由でダウンロードできるようになります。
何かしらへのHTTPアクセスが絶対に必要な場合は無効にできますが、[Let's
Encrypt](https://letsencrypt.org/)を使用して無料のSSL証明書を取得する方が一般的にはより良い代替手段です。

## bitbucket-oauth

ドメイン名と消費者のリストです。
例えば`{"bitbucket.org": {"consumer-key": "myKey", "consumer-secret":
"mySecret"}}`のように使います。
より詳しくは[こちら](articles/authentication-for-private-packages.md#bitbucket-oauth)を読んでください。

## cafile

ローカルファイルシステム上の認証局ファイルの配置場所です。
PHP 5.6以降ではシステムCAファイルを自動的に検出ができますが、PHP
5.6以降でも、php.iniのopenssl.cafileを介してこれを設定すべきです。

## capath

cafileが指定されていない場合、またはそこに証明書が見つからない場合は、capathが指すディレクトリで適切な証明書が探索されます。
capathは正しくハッシュされた証明書ディレクトリでなければなりません。

## http-basic

認証するためのドメイン名と、ユーザー名とパスワードのリストです。
たとえば、このオプションの値として`{"example.org": {"username": "alice", "password":
"foo"}}`を使用すると、Composerはexample.orgに対して認証します。
詳細については、[こちら](articles/authentication-for-private-packages.md#http-basic)を参照してください。

## bearer

認証するドメイン名とトークンのリストです。
たとえば、このオプションの値として`{"example.org": "foo"}`を使用すると、Composerは`Authorization:
Bearer foo`ヘッダーを使用してexample.orgに対して認証を行うことができます。

## platform

プラットフォームパッケージ（PHP
および拡張機能）を偽装して、運用環境をエミュレートしたり、構成で対象のプラットフォームを定義したりできるようにします。
例えば`{"php": "7.0.3", "ext-something": "4.0.3"}`です。

これにより、ローカルで実行する実際のPHPバージョンに関係なく、PHP 7.0.3以上を必要とするパッケージをインストールできなくなります。
ただし、依存関係が正しくチェックされなくなったことも意味します。
PHP 5.6を実行すると、7.0.3を想定しているため問題なくインストールされますが、実行時に失敗します。
これは、`{"php":"7.4"}`が指定されている場合も意味します。
`7.4.1`を最小のバージョンとして定義するパッケージは使用されません。

したがって、これを使用する場合は、デプロイ戦略の一部として[`check-platform-reqs`](03-cli.md#check-platform-reqs)コマンドも走らせることをお勧めしますし、より安全です。

ローカルにインストールしていない拡張機能が依存関係に必要な場合は、代わりに`--ignore-platform-req=ext-foo`を`update`、`install`、または`require`に渡して無視できます。
しかし長い目で見れば、今は無視するにせよ必要な拡張はインストールすべきで、1箇月後に新しいパッケージでも必要になると、知らず知らずのうちに本番環境に問題が発生する可能性があります。

拡張をローカルにインストールしているが本番環境では*そうではない*場合、`{"ext-foo":
false}`を使ってComposerから意図的に隠すこともできます。

## vendor-dir

既定は`vendor`です。
お好みで違うディレクトリに依存関係をインストールできます。
vendor-dirと以下の全ての`*-dir`オプション中では、`$HOME`と`~`はホームディレクトリに置換されます。

## bin-dir

既定では`vendor/bin`です。
プロジェクトがバイナリを含む場合、それらのバイナリはこのディレクトリにシンボリックリンクが張られます。

## data-dir

既定では、Windowsでは`C:\Users\<user>\AppData\Roaming\Composer`、XDG Base Directory Specificationsに従うunixシステムでは`$XDG_DATA_HOME/composer`、その他のunixシステムでは`$COMPOSER_HOME`です。
現在、過去のcomposer.pharファイルを保存して古いバージョンにロールバックできるようにするためにのみ使用されています。
[COMPOSER_HOME](03-cli.md#composer-home)も参照してください。

## cache-dir

既定では、Windowsでは`C:\Users\<user>\AppData\Local\Composer`、macOSでは`/Users/<user>/Library/Caches/composer`、XDG Base Directory Specificationに従うunixシステムでは`$XDG_CACHE_HOME/composer`、他のunixシステムでは`$COMPOSER_HOME/cache`になります。
Composerで使う全てのキャッシュが保管されます。
[COMPOSER_HOME](03-cli.md#composer-home)も参照してください。

## cache-files-dir

既定では`$cache-dir/files`です。
パッケージのzipアーカイブを保管します。

## cache-repo-dir

既定では`$cache-dir/repo`です。
`composer`の種別用のリポジトリのメタデータと、`svn`、`fossil`、`github`、`gitbucket`の種別のVCSリポジトリを保管します。

## cache-vcs-dir

既定では`$cache-dir/vcs`です。
`git`及び`hg`の種別用のVCSリポジトリメタデータを読み込むためのVCSクローンを保管し、インストールを高速にします。

## cache-files-ttl

既定では`15552000`（6箇月）です。
Composerはダウンロードした全てのdist（zip、tar、……）をキャッシュします。
既定では使われていないものについて6箇月経った後に削除します。
このオプションはこの期間を（秒数で）調整ないし0に設定することで完全に無効にできるようにするものです。

## cache-files-maxsize

既定では`300MiB`です。
Composerはダウンロードした全ての配布パッケージ（zip、tar、……）をキャッシュします。
ガベージコレクションが定期的に走っている場合、これはキャッシュで使える最大量です。
最後のキャッシュヒットから時間が経った（比較的使われていない）ファイルが削除されます。

## cache-read-only

既定では`false`です。
Composerのキャッシュを読取専用モードで使うかどうかを決めます。

## bin-compat

既定では`auto`です。
インストールするバイナリの互換性を決定します。
`auto`の場合、Composerは、WindowsまたはWSLの場合に.batプロキシファイルのみをインストールします。
`full`に設定すると、Windows用の.batファイルとUnixベースのオペレーティングシステム用のスクリプトの両方がバイナリごとにインストールされます。
これは主に、Linux VM内でComposerを実行しているが、WindowsホストOSで使用できる`.bat`プロキシが必要な場合に役立ちます。
`proxy`に設定すると、ComposerはbashでUnixスタイルのプロキシファイルのみを作成し、WindowsないしWSLでも.batファイルを作成しません。

## prepend-autoloader

既定は`true`です。
`false`にするとComposerの自動読み込み器は既存の自動読み込み器の前に置かれなくなります。
これは他の自動読み込み器との相互運用性の問題を修正する際に必要になることがあります。

## autoloader-suffix

既定では`null`です。
空でない文字列は生成されたComposerの自動読み込み器の拡張子に使われます。
空の場合乱択されたものが生成されます。

## optimize-autoloader

既定では`false`です。
`true`の場合、自動読み込み器を吐き出す際に常に最適化されます。

## sort-packages

既定では`false`です。
`true`の場合、新しいパッケージを追加したときに`composer.json`中の`require`コマンドでパッケージが名前順に整列された状態に保ちます。

## classmap-authoritative

既定では`false`です。
`true`にするとComposerの自動読み込み器はクラスマップからのクラスのみを読み込みます。
暗に`optimize-autoloader`を有効にします。

## apcu-autoloader

既定では`false`です。
`true`の場合、Composerの自動読み込み器はAPCuを確認し、拡張が有効になった場合に見付かったり見付からなかったりしたクラスをキャッシュするのに使います。

## github-domains

既定では`["github.com"]`です。
githubモードで使われるドメインのリストです。
これはGitHub Enterpriseの準備で使われます。

## github-expose-hostname

既定では`true`です。
`false`にするとgithub APIにアクセスするために作られるOAuthトークンがマシンのホスト名ではなく日付になります。

## use-github-api

既定では`true`です。
特定のリポジトリにおける`no-api`キーに似ており、`use-github-api`を`false`に設定すると、他のgitリポジトリのように、全てのGitHubリポジトリについてGitHub
APIを使う代わりにリポジトリをクローンするように大域的な挙動を定義します。
しかし`git`ドライバを直接使うのとは異なり、ComposerはやはりGitHubのzipファイルを使うことを試みます。

## notify-on-install

既定では`true`です。
Composerではリポジトリが通知のURLを定義できるようにしており、そのリポジトリからパッケージがインストールされたことの通知を受けられます。
このオプションはその挙動を無効にできます。

## discard-changes

既定では`false`で、`true`、`false`、または`stash`のいずれかにできます。
このオプションでは非対話モードでダーティアップデートを制御する既定の方式を設定できます。
`true`はベンダーの変更を常に破棄しますが、`"stash"`は取っておいて再適用しようとします。
よくベンダーを変更する場合はCIサーバーやデプロイスクリプトにこれを使ってください。

## archive-format

既定では`tar`です。
archiveコマンドにより使われる既定の形式を上書きします。

## archive-dir

既定では`.`です。
archiveコマンドによる作られる、アーカイブの既定の対象パスです。

例：

```json
{
    "config": {
        "archive-dir": "/home/user/.composer/repo"
    }
}
```

## htaccess-protect

既定では`true`です。
`false`に設定するとComposerはComposerのホーム、キャッシュ、データディレクトリに`.htaccess`ファイルを作りません。

## lock

既定では`true`です。
`false`に設定するとComposerは`composer.lock`ファイルを作らず、存在している場合は無視します。

## platform-check

既定では、PHPのバージョンのみをチェックする`php-only`に設定されています。
拡張子の存在も確認するには、`true`に設定します。
`false`に設定すると、Composerは自動読み込み器のブートストラップの一部として`platform_check.php`ファイルを作成せず、requireもしません。

## secure-svn-domains

既定では`[]`です。
安全なSubversionまたはSVNの移送を使用しているものとして信頼ししマークするべきドメインの一覧です。
既定では、svn://プロトコルは安全ではないと見なされ、throwされますが、この構成オプションを`["example.org"]`に設定すれば、そのホスト名でsvnのURLを使用できます。
これは、`secure-http`を完全に無効にするよりも優れた安全な代替手段です。

&larr; [リポジトリ](05-repositories.md)  | [実行時](07-runtime.md) &rarr;
