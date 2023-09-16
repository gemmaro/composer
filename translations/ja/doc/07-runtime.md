# 実行時Composerユーティリティ

Composerはほぼプロジェクトに依存関係をインストールするのに使われますが、実行時に使える機能もいくつかあります。

特定のバージョンにおけるこれらの機能のどれかに依る必要があれば、`composer-runtime-api`パッケージをrequireできます。

## 自動読み込み

自動読み込み器は最も使われるものであり、既に[基本的な使い方の手引き](01-basic-usage.md#autoloading)で押さえられています。
全てのComposerのバージョンで使えます。

## インストールされたバージョン

composer-runtime-api
2.0では、現在インストールされているバージョンを調べるための静的メソッドを提供する新しい`Composer\InstalledVersions`クラスが導入されました。
Composerの自動読み込み器が含まれている限り、コードで自動的に使用できます。

このクラスの主な用例は以下の通りです。

### パッケージX（あるいはバーチャルパッケージ）が存在するか見る

```php
\Composer\InstalledVersions::isInstalled('vendor/package'); // 真偽値を返す
\Composer\InstalledVersions::isInstalled('psr/log-implementation'); // 真偽値を返す
```

Composer 2.1から、2つ目の引数に偽を渡すことによりrequire-devを介してインストールされたかを確認することもできます。

```php
\Composer\InstalledVersions::isInstalled('vendor/package'); // このパッケージがインストールされていれば真を返す
\Composer\InstalledVersions::isInstalled('vendor/package', false); // vendor/packageがrequireにあれば真を、require-devにあれば偽を返す
```

なおこれはプラットフォームパッケージがインストールされているかどうかを確認するのには使えません。

### パッケージXのバージョンYがインストールされているかどうかを見る

> **補足：** これを使うためには`"composer/semver": "^3.0"`をrequireしなければなりません。

```php
use Composer\Semver\VersionParser;

\Composer\InstalledVersions::satisfies(new VersionParser, 'vendor/package', '2.0.*');
\Composer\InstalledVersions::satisfies(new VersionParser, 'psr/log-implementation', '^1.0');
```

これは例えば、vendor/packageについて、`2.0.*`に適合するバージョンでインストールされている場合だけでなく、与えられたパッケージ名が何らかの他のパッケージにより置き換えられていたり与えられていたりする場合にも真を返します。

### パッケージのバージョンを見る

> **補足：** 求めるパッケージ名自体がインストールされていないものの他のパッケージから与えられていたり置き換えられていたりする場合は`null`を返します。
> したがって少なくともライブラリのコードでsatisfies()を使うことをお勧めします。
> アプリケーションのコードではもう少し制御できるためあまり重要ではありません。

```php
// vendor/packageがインストールされている場合、正規化されたバージョン（例：1.2.3.0）が返ります。
// パッケージが提供されたり置き換えられたりしたものであればnullを返します。
// パッケージが全くインストールされていなければOutOfBoundsExceptionを投げます。
\Composer\InstalledVersions::getVersion('vendor/package');
```

```php
// vendor/packageがインストールされていれば元のバージョン（例：v1.2.3）を返します。
// 提供されたり置き換えられたりしたものであればnullを返します。
// パッケージが全くインストールされていなければOutOfBoundsExceptionを投げます。
\Composer\InstalledVersions::getPrettyVersion('vendor/package');
```

```php
// vendor/packageがインストールされていればパッケージのdistまたはソースの参照（例：gitのコミットハッシュ）を返します。
// 提供されたり置き換えられたりしたものであればnullを返します。
// そのパッケージが全くインストールされていなければOutOfBoundsExceptionを投げます。
\Composer\InstalledVersions::getReference('vendor/package');
```

### パッケージ自体のインストールされたバージョンを見る

パッケージ自体のバージョンを取得することにのみ関心がある場合、getVersion/getPrettyVersion/getReferenceで充分でしょう。
例えばacme/fooのソースで、現在実行中のacme/fooのバージョンがどれかを利用者に表示したい場合などです。

上の節の警告はこの場合には適用されません。
なぜならコードが走っている場合はパッケージは存在しており置き換えられてもいないからです。

とはいうものの、できる限りの安全性のために`null`の返り値まで心を配って制御することは良い考えです。

----

より複雑な用例については他の方法がいくつか利用できます。
[クラス自体](https://github.com/composer/composer/blob/main/src/Composer/InstalledVersions.php)のソースやドキュメント部分を参照してください。

### パッケージがインストールされているパスを見る

`getInstallPath`メソッドはパッケージがインストールされている絶対パスを取得します。

> **補足：** パスは絶対的ではありますが、`../`やシンボリックリンクは含まれることがあります。
> `realpath()`と等価なものであるという保証はないので、問題に挙がる状況ではrealpathを走らせるべきです。

```php
// vendor/packageがインストールされていればパッケージのインストール場所への絶対パスを返します。
// 提供されていたり置き換えられていたり、あるいはパッケージがメタパッケージの場合はnullを返します。
// そのパッケージが全くインストールされていなければOutOfBoundsExceptionを投げます。
\Composer\InstalledVersions::getInstallPath('vendor/package');
```

> Composer 2.1から使えます（つまり`composer-runtime-api ^2.1`です）

### 与えられた種類でどのパッケージがインストールされているのかを見る

`getInstalledPackagesByType`メソッドはパッケージの種類（例：foo-plugin）を受け入れ、インストールされているその種類のパッケージを一覧表示します。
その後、上記のメソッドを使用して、必要に応じて各パッケージに関する詳細情報を取得できます。

この方法により、プラグインをベンダーディレクトリに残すのではなく、特定のパスに配置するカスタムインストーラーの必要性が軽減されます。
それからInstalledVersionsを介して実行時に初期化するプラグインを見付け、必要に応じてgetInstallPathを介してそれらのパスを含めることができます。

```php
\Composer\InstalledVersions::getInstalledPackagesByType('foo-plugin');
```

> Composer 2.1から使えます（つまり`composer-runtime-api ^2.1`です）

## プラットフォームの検査

composer-runtime-api
2.0では新しい`vendor/composer/platform_check.php`ファイルが導入されました。
これはComposerの自動読み込み器を含めた際に自動的に含まれます。

プラットフォーム要件（つまり、phpおよびphp拡張機能）が現在実行中のPHPプロセスで満たされていることを確認します。
要件が満たされていない場合、スクリプトは不足している要件に関する警告を出力し、コード104で終了します。

実稼働環境でPHP拡張機能の曖昧な警告が表示される予期せず失敗した際の空白ページを回避するには、デプロイやビルドの工程の一部として`composer
check-platform-reqs`を実行し、0以外のコードが返された場合に中止すると良いでしょう。

既定値は`php-only`であり、PHPのバージョンのみを検査します。

何らかの理由でこの安全性の検査を使いたくなく、コードが実行されるときの実行時エラーの危険性を許容する場合は[`platform-check`](06-config.md#platform-check)構成オプションを`false`に設定することで無効にできます。

検査にPHP拡張機能が存在することの検証を含めたい場合は、configオプションを`true`に設定します。
その後、`ext-*`の要件が検証されますが、効率上の理由から、Composerは拡張機能の存在のみをチェックし、その正確なバージョンは検査しません。

`lib-*`の要件はプラットフォーム検査機能では全く対応されておらず検査もされません。

## バイナリの自動読み込みパス

composer-runtime-api
2.2では、Composerでインストールされたバイナリを実行するときに設定される`$_composer_autoload_path`大域変数が新しく導入されました。
詳細については、[ベンダーバイナリドキュメント](articles/vendor-binaries.md#finding-the-composer-autoloader-from-a-binary)を参照してください。

これはバイナリプロキシによって設定され、そうしたわけでComposerの`vendor/autoload.php`ではプロジェクトに使うことはできません。
このファイルはそれ自体を指すように戻ってしまうので役に立たないのです。

## バイナリのバイナリパス (bin-dir)

composer-runtime-api 2.2.2では新しい`$_composer_bin_dir`大域変数が導入されました。
これはComposerでインストールされたバイナリを使った際に設定されます。
これについての詳細は[ベンダーバイナリのドキュメント](articles/vendor-binaries.md#finding-the-composer-bin-dir-from-a-binary)をお読みください。

これはバイナリプロキシによって設定され、そうしたわけでComposerの`vendor/autoload.php`によるプロジェクトでは利用できません。

&larr; [構成](06-config.md)  | [コミュニティ](08-community.md) &rarr;
