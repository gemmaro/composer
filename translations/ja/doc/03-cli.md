# コマンドラインインターフェース / コマンド

すでにいろいろなことをするために、コマンドラインインターフェースの使い方は学びました。
この章は全ての利用可能なコマンドを説明します。

コマンドラインからヘルプを得るためには、`composer`または`composer
list`を実行して全てのコマンドの完全な一覧を見ることができます。
さらに`--help`をそれらのコマンドと組み合わせればより多くの情報を得られます。

Composerは[symfony/console](https://github.com/symfony/console)を使っているため曖昧でなければ短い名前でコマンドを呼び出せます。
```shell
php composer.phar dump
```
上では`composer dump-autoload`を呼び出します。

## Bashの補完

Bashの補完をインストールするには`composer completion bash > completion.bash`と走らせられます。
これは現在のディレクトリに`completion.bash`ファイルを作ります。

それから`source completion.bash`を実行すれば現在の端末のセッションで有効になります。

`completion.bash`を`/etc/bash_completion.d/composer`に移動しつつ改名すれば新しい端末で自動的に読み込まれるようにできます。

## 大域オプション

以下のオプションは全てのコマンドで利用できます。

* **--verbose (-v):** メッセージの冗長さを増やす。
* **--help (-h):** ヘルプ情報を表示する。
* **--quiet (-q):** メッセージを一切出力しない。
* **--no-interaction (-n):** インタラクティブな質問の問い合わせを一切おこなわない。
* **--no-plugins:** プラグインを無効にする。
* **--no-scripts:** `composer.json`で定義されているスクリプトの実行をスキップする。
* **--no-cache:** キャッシュディレクトリの使用を無効にする。
  COMPOSER_CACHE_DIR環境変数を`/dev/null`（WindowsではNUL）に設定することと同じです。
* **--working-dir (-d):** 指定すると、与えられたディレクトリを作業ディレクトリに使う。
* **--profile:** 時間とメモリ使用量の情報を表示する。
* **--ansi:** ANSI出力を強制する。
* **--no-ansi:** ANSI出力を行わない。
* **--version (-V):** 本アプリケーションのバージョンを表示する。

## プロセスの終了コード

* **0:** OK
* **1:** 一般的ないし不明なエラーコード
* **2:** 依存解決エラーコード

## init

[ライブラリ](02-libraries.md)の章で`composer.json`を手作りする方法を見ました。
こうしたことをするのに`init`コマンドというのもあります。

このコマンドを実行すると、スマートな既定値を使いながら、対話的な問答を経てフィールドが埋められていきます。

```shell
php composer.phar init
```

### オプション

* **--name:** パッケージの名前。
* **--description:** パッケージの説明。
* **--author:** パッケージの作者名。
* **--type:** パッケージの種類。
* **--homepage:** パッケージのホームページ。
* **--require:** バージョン制約付きの必要なパッケージ。書式は`foo/bar:1.0.0`のようになります。
* **--require-dev:** 開発のための要件です。**--require**を参照。
* **--stability (-s):** `minimum-stability`フィールド用の値。
* **--license (-l):** パッケージの利用許諾。
* **--repository:** 1つ（かそれ以上）の個別のリポジトリを与えます。
  これらのリポジトリは生成されるcomposer.jsonに収められ、要件の一覧を提案する際の自動補完に使われます。
  全てのリポジトリは`composer`リポジトリを指すHTTPのURLないし[repositories](04-schema.md#repositories)キーが受け付けるものに似たようなJSON文字列のいずれかを取ります。
* **--autoload (-a):** composer.jsonへのPSR-4自動読み込みの対応付けを加えます。
  自動的にパッケージの名前空間を与えられたディレクトリに対応付けます（src/のような相対パスを想定しています）。
  [PSR-4自動読み込み](04-schema.md#psr-4)も参照してください。

## install / i

`install`コマンドは現在のディレクトリから`composer.json`ファイルを読み込み、依存物を解決し、`vendor`配下にインストールします。

```shell
php composer.phar install
```

現在のディレクトリに`composer.lock`ファイルが存在する場合は、依存物を解決する代わりに、そこから厳密なバージョンを使います。
これはライブラリを使う全ての利用者が同じバージョンの依存物を持つことを保証します。

`composer.lock`ファイルがない場合、composerは依存物を解決したあとで作成します。

### オプション

* **--prefer-install:** パッケージをダウンロードする方法は2つあり、`source` と`dist`です。
  Composerは`dist`を既定で使います。
  `--prefer-install=source`（または`--prefer-source`）を渡すとComposerはもしあれば`source`からインストールします。
  これはプロジェクトへのバグ修正をして依存関係のローカルgitクローンを直接取得したい場合に便利です。
  Composerがパッケージの開発版用の`source`を自動的に使う過去の挙動にしたければ、`--prefer-install=auto`を使ってください。
  [config.preferred-install](06-config.md#preferred-install)も参照してください。
  このフラグを渡すと設定値より優先されます。
* **--dry-run:**
  実際にパッケージをインストールすることなくインストールの過程を進めたいときは`--dry-run`を使うことができます。
  これはインストールを模擬して何が起こるのかを示します。
* **--download-only:** ダウンロードのみで、パッケージをインストールしません。
* **--dev:** `require-dev`に挙げられたパッケージをインストールします（これは既定の挙動です）。
* **--no-dev:** `require-dev`に挙げられたパッケージのインストールを飛ばします。
  自動読み込み器の生成で`autoload-dev`規則を読み飛ばします。
  [COMPOSER_NO_DEV](#composer-no-dev)も参照してください。
* **--no-autoloader:** 自動読み込み器の生成を飛ばします。
* **--no-progress:** 端末を散らかしかねない進捗表示やバックスペース文字を扱わないスクリプトを除きます。
* **--audit:** インストールが完了した後に監査を走らせます。
* **--audit-format:** 監査の出力形式です。
  "table"、"plain"、"json"、または"summary"（既定）のどれかでなければなりません。
* **--optimize-autoloader (-o):** PSR-0の自動読み込みをクラス対応表に変換して自動読み込みを高速にします。
  実運用では特にお勧めしますが、走らせるのに少し時間が掛かることがあるので現在は既定ではされません。
* **--classmap-authoritative (-a):** クラス対応表からクラスのみを自動読み込みします。
  暗黙裡に`--optimize-autoloader`を有効にします。
* **--apcu-autoloader:** APCuを使ってクラスの有無をキャッシュします。
* **--apcu-autoloader-prefix:** APCu自動読み込み器のキャッシュ用に独自の接頭辞を使います。
  暗黙裡に`--apcu-autoloader`を有効にします。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  [`platform`](06-config.md#platform)設定オプションも参照してください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  ワイルドカードを使って複数の要件を無視できます。
  `+`を後ろに付けることで要件の上限値だけを無視できます。
  例えばパッケージが`php:
  ^7`を要求しているとき、オプション`--ignore-platform-req=php+`はPHP8のインストールを許しますが、PHP
  5.6のインストールについては失敗したままになります。

## update / u / upgrade

依存関係の最新版を取得して`composer.lock`ファイルを更新する上では`update`コマンドを使うと良いでしょう。このコマンドは`upgrade`の別名が付けられていますが、これは`apt-get`や類するパッケージ管理を連想したときに`upgrade`がすることと同じだからです。

```shell
php composer.phar update
```

これはプロジェクトの全ての依存関係を解決し厳密なバージョンを`composer.lock`に書き込みます。

全てではなく、2、3のパッケージのみを更新したい場合は、それらを以下のように列挙できます。

```shell
php composer.phar update vendor/package vendor/package2
```

ワイルドカードを使って複数のパッケージを一挙に更新することもできます。

```shell
php composer.phar update "vendor/*"
```


`composer.json`を変えることなくパッケージを指定のバージョンに巻き戻したいときは、`--with`を使うことができます。このオプションには自分で選んだバージョン制約を与えます。

```shell
php composer.phar update --with vendor/package:2.0.1
```

なお上記では全てのパッケージが更新されます。`--with`を使って自分で選んだ制約を与えたパッケージのみを更新したければ、`--with`を省いて代わりに部分更新構文を伴う制約を使うことができます。

```shell
php composer.phar update vendor/package:2.0.1 vendor/package2:3.0.*
```

> **補足：** composer.jsonでも要求されているパッケージについては、自分で選んだ制約は既存の制約の部分集合でなければなりません。
> これらの一時的な更新制約があっても、composer.jsonの制約はやはり適用されcomposer.jsonは更新されません。


### オプション

* **--prefer-install:** パッケージをダウンロードする方法は2つあり、`source` と`dist`です。
  Composerは`dist`を既定で使います。
  `--prefer-install=source`（または`--prefer-source`）を渡すとComposerはもしあれば`source`からインストールします。
  これはプロジェクトへのバグ修正をして依存関係のローカルgitクローンを直接取得したい場合に便利です。
  Composerがパッケージの開発版用の`source`を自動的に使う過去の挙動にしたければ、`--prefer-install=auto`を使ってください。
  [config.preferred-install](06-config.md#preferred-install)も参照してください。
  このフラグを渡すと設定値より優先されます。
* **--dry-run:** 実際に何もせずにコマンドを模擬します。
* **--dev:** `require-dev`に挙げられたパッケージをインストールします（これは既定の挙動です）。
* **--no-dev:** `require-dev`に挙げられたパッケージのインストールを飛ばします。
  自動読み込み器の生成で`autoload-dev`規則を読み飛ばします。
  [COMPOSER_NO_DEV](#composer-no-dev)も参照してください。
* **--no-install:** composer.lockを更新したあとのインストール過程を走らせません。
* **--no-audit:**
  composer.lockを更新した後の監査過程を走らせません。[COMPOSER_NO_AUDIT](#composer-no-audit)も参照してください。
* **--audit-format:** 監査の出力形式です。
  "table"、"plain"、"json"、または"summary"（既定）のどれかでなければなりません。
* **--lock:** ロックファイルのハッシュのみを更新し、ロックファイルが期限切れになっていることについての警告を抑制します。
* **--with:** 一時的に追加するバージョン制約です。例えばfoo/bar:1.0.0やfoo/bar=1.0.0です。
* **--no-autoloader:** 自動読み込み器の生成を飛ばします。
* **--no-progress:** 端末を散らかしかねない進捗表示やバックスペース文字を扱わないスクリプトを除きます。
* **--with-dependencies (-w):** 引数リストにあるパッケージの依存関係も更新します。ただしルート要件は除きます。
* **--with-all-dependencies (-W):** 引数リスト中にあるパッケージの依存関係を更新します。ルート要件を含みます。
* **--optimize-autoloader (-o):**
  PSR-0自動読み込みをクラスマップに変換してより高速な自動読み込み器を取得します。これは特に実運用で推奨されますが、走らせるのに少し時間が掛かるため現時点では既定では有効になっていません。
* **--classmap-authoritative (-a):** クラス対応表からクラスのみを自動読み込みします。
  暗黙裡に`--optimize-autoloader`を有効にします。
* **--apcu-autoloader:** APCuを使ってクラスの有無をキャッシュします。
* **--apcu-autoloader-prefix:** APCu自動読み込み器のキャッシュ用に独自の接頭辞を使います。
  暗黙裡に`--apcu-autoloader`を有効にします。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  [`platform`](06-config.md#platform)設定オプションも参照してください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  ワイルドカードを使って複数の要件を無視できます。
  `+`を後ろに付けることで要件の上限値だけを無視できます。
  例えばパッケージが`php:
  ^7`を要求しているとき、オプション`--ignore-platform-req=php+`はPHP8のインストールを許しますが、PHP
  5.6のインストールについては失敗したままになります。
* **--prefer-stable:**
  依存関係の安定板を選ぶようにします。COMPOSER_PREFER_STABLE=1環境変数を介しても設定できます。
* **--prefer-lowest:**
  依存関係の最も低いバージョンを選ぶようにします。最小バージョン要件を試す際に便利で、一般的には`--prefer-stable`と共に使われます。COMPOSER_PREFER_LOWERST=1環境変数を介しても設定できます。
* **--interactive:** 自動補完付きの対話的なインターフェースで更新するパッケージを選択します。
* **--root-reqs:** 更新を一次依存関係に制限します。

引数として単語`mirrors`、`lock`、`nothing`から1つを指定すると、オプション`--lock`を指定することと同じ効果があります。例えば`composer
update mirrors`は`composer update --lock`と全く同じです。

## require / r

`require`コマンドは`composer.json`ファイルに現在のディレクトリから新しいパッケージを追加します。1つもファイルが存在しなければ必要に応じて作られます。

```shell
php composer.phar require
```

要件を加えたり変えたりしたあと、変更された要件はインストールされたり更新されたりします。

対話的に要件を選びたくなければコマンドに渡すこともできます。

```shell
php composer.phar require "vendor/package:2.*" vendor/package2:dev-master
```

パッケージを指定しない場合、Composerはパッケージを探すためにプロンプトを出し、要件にするものに照合する一覧を提供します。

### オプション

* **--dev:** パッケージを`require-dev`に追加します。
* **--dry-run:** 実際に何もせずにコマンドを模擬します。
* **--prefer-install:** パッケージをダウンロードする方法は2つあり、`source` と`dist`です。
  Composerは`dist`を既定で使います。
  `--prefer-install=source`（または`--prefer-source`）を渡すとComposerはもしあれば`source`からインストールします。
  これはプロジェクトへのバグ修正をして依存関係のローカルgitクローンを直接取得したい場合に便利です。
  Composerがパッケージの開発版用の`source`を自動的に使う過去の挙動にしたければ、`--prefer-install=auto`を使ってください。
  [config.preferred-install](06-config.md#preferred-install)も参照してください。
  このフラグを渡すと設定値より優先されます。
* **--no-progress:** 端末を散らかしかねない進捗表示やバックスペース文字を扱わないスクリプトを除きます。
* **--no-update:** 依存関係の自動的な更新を無効にします（--no-installを暗示します）。
* **--no-install:** composer.lockを更新したあとのインストール過程を走らせません。
* **--no-audit:**
  composer.lockを更新した後の監査過程を走らせません。[COMPOSER_NO_AUDIT](#composer-no-audit)も参照してください。
* **--audit-format:** 監査の出力形式です。
  "table"、"plain"、"json"、または"summary"（既定）のどれかでなければなりません。
* **--update-no-dev:**
  `--no-dev`オプションと共に依存関係の更新を走らせます。[COMPOSER_NO_DEV](#composer-no-dev)も参照してください。
* **--update-with-dependencies (-w):**
  新しく要求するパッケージの依存関係も更新します。ただしルート要件は除きます。
* **--update-with-all-dependencies (-W):**
  新しく要求するパッケージの依存関係も更新します。ルート要件も含まれます。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  [`platform`](06-config.md#platform)設定オプションも参照してください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`それから`ext-*`）を無視して、たとえローカルマシンが満たしていなかったとしても、インストールを強行します。
  ワイルドカードを使って複数の要件を無視できます。
* **--prefer-stable:**
  依存関係の安定板を選ぶようにします。COMPOSER_PREFER_STABLE=1環境変数を介しても設定できます。
* **--prefer-lowest:**
  依存関係の最も低いバージョンを選ぶようにします。最小バージョン要件を試す際に便利で、一般的には`--prefer-stable`と共に使われます。COMPOSER_PREFER_LOWERST=1環境変数を介しても設定できます。
* **--sort-packages:** パッケージを`package.json`で並び換えた状態にします。
* **--optimize-autoloader (-o):**
  PSR-0自動読み込みをクラスマップに変換してより高速な自動読み込み器を取得します。これは特に実運用で推奨されますが、走らせるのに少し時間が掛かるため現時点では既定では有効になっていません。
* **--classmap-authoritative (-a):** クラス対応表からクラスのみを自動読み込みします。
  暗黙裡に`--optimize-autoloader`を有効にします。
* **--apcu-autoloader:** APCuを使ってクラスの有無をキャッシュします。
* **--apcu-autoloader-prefix:** APCu自動読み込み器のキャッシュ用に独自の接頭辞を使います。
  暗黙裡に`--apcu-autoloader`を有効にします。

## remove / rm

`remove`コマンドは現在のディレクトリにある`composer.json`ファイルからパッケージを削除します。

```shell
php composer.phar remove vendor/package vendor/package2
```

要件を削除したあとは変更対象の要件がアンインストールされます。

### オプション

* **--unused**（もう）直接ないし間接の依存関係ではない、使われていないパッケージを削除します。
* **--dev:** `require-dev`からパッケージを削除します。
* **--dry-run:** 実際に何もせずにコマンドを模擬します。
* **--no-progress:** 端末を散らかしかねない進捗表示やバックスペース文字を扱わないスクリプトを除きます。
* **--no-update:** 依存関係の自動的な更新を無効にします（--no-installを暗示します）。
* **--no-install:** composer.lockを更新したあとのインストール過程を走らせません。
* **--no-audit:**
  インストールが完了したあとの監査過程を走らせないようにします。[COMPOSER_NO_AUDIT](#composer-no-audit)も参照してください。
* **--audit-format:** 監査の出力形式です。
  "table"、"plain"、"json"、または"summary"（既定）のどれかでなければなりません。
* **--update-no-dev:**
  --no-devオプションで依存関係の更新を走らせます。[COMPOSER_NO_DEV](#composer-no-dev)も参照してください。
* **--update-with-dependencies (-w):**
  削除されたパッケージの依存関係も更新します（時代遅れのオプションです。現在は規定の挙動になっています）。
* **--update-with-all-dependencies (-W):**
  全ての継承する依存関係が更新されるようにします。ルート依存関係のものも含みます。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  [`platform`](06-config.md#platform)設定オプションも参照してください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`それから`ext-*`）を無視して、たとえローカルマシンが満たしていなかったとしても、インストールを強行します。
  ワイルドカードを使って複数の要件を無視できます。
* **--optimize-autoloader (-o):** PSR-0の自動読み込みをクラス対応表に変換して自動読み込みを高速にします。
  実運用では特にお勧めしますが、走らせるのに少し時間が掛かることがあるので現在は既定ではされません。
* **--classmap-authoritative (-a):** クラス対応表からクラスのみを自動読み込みします。
  暗黙裡に`--optimize-autoloader`を有効にします。
* **--apcu-autoloader:** APCuを使ってクラスの有無をキャッシュします。
* **--apcu-autoloader-prefix:** APCu自動読み込み器のキャッシュ用に独自の接頭辞を使います。
  暗黙裡に`--apcu-autoloader`を有効にします。

## bump

`bump`コマンドはcomposer.jsonの要件の下限を現在インストールされているバージョンに引き上げます。これにより依存関係が何らかの競合によりうっかりダウングレードされてしまわないようになったり、Composerが探すパッケージのバージョンの数が抑えられるため依存関係解決を僅かに向上させられます。

許される依存関係を狭めてしまうため、ライブラリでこれを無闇に走らせるのは推奨**されません**。依存関係を狭めることは利用者に依存関係地獄を招きかねません。しかしライブラリで`--dev-only`を走らせるのは、開発用要件がライブラリに対して局所的でパッケージの消費者には影響しないため問題ないでしょう。

### オプション

* **--dev-only:** "require-dev" 中の要件のみbumpします。
* **--no-dev-only:** "require" にある要件のみbumpします。
* **--dry-run:** bumpするパッケージを出力しますが、何も実行しません。

## reinstall

`reinstall`コマンドは名前からインストールされているパッケージを見付けだし、アンインストールと再インストールをします。
こうすることでファイルを散らかしたり--prefer-installを使ってインストールの種類を変えたいと思ったりしたときにクリーンインストールできるのです。

```shell
php composer.phar reinstall acme/foo acme/bar
```

再インストールするパッケージ名を1つ以上指定できます。
またはワイルドカードを使って複数パッケージの一括選択もできます。

```shell
php composer.phar reinstall "acme/*"
```

### オプション

* **--prefer-install:** パッケージをダウンロードする方法は2つあり、`source` と`dist`です。
  Composerは`dist`を既定で使います。
  `--prefer-install=source`（または`--prefer-source`）を渡すとComposerはもしあれば`source`からインストールします。
  これはプロジェクトへのバグ修正をして依存関係のローカルgitクローンを直接取得したい場合に便利です。
  Composerがパッケージの開発版用の`source`を自動的に使う過去の挙動にしたければ、`--prefer-install=auto`を使ってください。
  [config.preferred-install](06-config.md#preferred-install)も参照してください。
  このフラグを渡すと設定値より優先されます。
* **--no-autoloader:** 自動読み込み器の生成を飛ばします。
* **--no-progress:** 端末を散らかしかねない進捗表示やバックスペース文字を扱わないスクリプトを除きます。
* **--optimize-autoloader (-o):** PSR-0の自動読み込みをクラス対応表に変換して自動読み込みを高速にします。
  実運用では特にお勧めしますが、走らせるのに少し時間が掛かることがあるので現在は既定ではされません。
* **--classmap-authoritative (-a):** クラス対応表からクラスのみを自動読み込みします。
  暗黙裡に`--optimize-autoloader`を有効にします。
* **--apcu-autoloader:** APCuを使ってクラスの有無をキャッシュします。
* **--apcu-autoloader-prefix:** APCu自動読み込み器のキャッシュ用に独自の接頭辞を使います。
  暗黙裡に`--apcu-autoloader`を有効にします。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件を無視します。これは再インストールコマンド用の自動読み込み器の生成のときにのみ効果があります。
* **--ignore-platform-req:** 特定のプラットフォーム要件を無視します。
  再インストールコマンド用の自動読み込み器の生成のときにのみ効果があります。
  複数の要件をワイルドカードで無視できます。

## check-platform-reqs

check-platform-reqsコマンドはPHPと拡張のバージョンがインストールされているパッケージのプラットフォーム要件を満たしているかを確認します。例えばこれは実運用サーバーでインストール後にプロジェクトを走らせるのに必要な全ての拡張があることを検証したいときに使えます。

updateやinstallとは異なり、このコマンドはconfig.platform設定を無視し、実際のプラットフォームパッケージを検査します。
そのため要求されているプラットフォーム依存関係があることを確かめられます。

### オプション

* **--lock:** インストールされたパッケージからではなく、ロックファイルのみから要件を検査します。
* **--no-dev:** require-devのパッケージ要件の検査を無効にします。
* **--format (-f):** 出力の書式です。text（既定）またはjsonです。

## global

globalコマンドは`install`、`remove`、`require`、`update`のようなコマンドをあたかも[COMPOSER_HOME](#composer-home)ディレクトリから走らせているように実行できます。

これは中心的な場所に保管されたプロジェクトを管理するためのただの補助であり、CLIツールやComposerプラグインのようなどこでも使えるようにしたいものを置いておけます。

これがあれば大域的にCLIユーティリティをインストールするのに使えます。以下は一例です。

```shell
php composer.phar global require friendsofphp/php-cs-fixer
```

これで`php-cs-fixer`バイナリが大域的に使えるようになりました。大域的な[ベンダーバイナリ](articles/vendor-binaries.md)ディレクトリが`$PATH`環境変数の中にあるようにしてください。インストールした場所は以下のコマンドで得られます。

```shell
php composer.phar global config bin-dir --absolute
```

後になってバイナリを更新したいと思ったらglobal updateを走らせられます。

```shell
php composer.phar global update
```

## search

searchコマンドを使うと現在のプロジェクトのパッケージリポジトリ全体を検索できます。
大抵これはpackagistです。
検索したい用語を渡せます。

```shell
php composer.phar search monolog
```

複数の引数を渡すことで1つ以上の用語を探すこともできます。

### オプション

* **--only-name (-N):** パッケージの名前のみから検索します。
* **--only-vendor (-O):** ベンダー・組織名のみから検索します。結果としては "vendor" のみが返ります。
* **--type (-t):** 特定のパッケージの種類から探します。
* **--format (-f):**
  text（既定）かjson出力かのどちらかを選べます。jsonでは名前と説明のキーのみについて存在することが保証されています。残り（`url`、`repository`、`downloads`、`favers`）はPackagist.orgの検索結果で得られるものであって、その他のリポジトリが返す情報はそれより多かったり少なかったりします。

## show / info

使えるパッケージの全てを一覧にするには`show`コマンドが使えます。

```shell
php composer.phar show
```

リストを絞り込むにはワイルドカードを使ってパッケージマスクを渡すことができます。

```shell
php composer.phar show "monolog/*"
```
```text
monolog/monolog 2.4.0 Sends your logs to files, sockets, inboxes, databases and various web services
```

何かのパッケージの詳細を見たければパッケージ名を渡すことができます。

```shell
php composer.phar show monolog/monolog
```
```text
name     : monolog/monolog
descrip. : Sends your logs to files, sockets, inboxes, databases and various web services
keywords : log, logging, psr-3
versions : * 1.27.1
type     : library
license  : MIT License (MIT) (OSI approved) https://spdx.org/licenses/MIT.html#licenseText
homepage : http://github.com/Seldaek/monolog
source   : [git] https://github.com/Seldaek/monolog.git 904713c5929655dc9b97288b69cfeedad610c9a1
dist     : [zip] https://api.github.com/repos/Seldaek/monolog/zipball/904713c5929655dc9b97288b69cfeedad610c9a1 904713c5929655dc9b97288b69cfeedad610c9a1
names    : monolog/monolog, psr/log-implementation

support
issues : https://github.com/Seldaek/monolog/issues
source : https://github.com/Seldaek/monolog/tree/1.27.1

autoload
psr-4
Monolog\ => src/Monolog

requires
php >=5.3.0
psr/log ~1.0
```

パッケージのバージョンを渡すことさえでき、こうすると特定のバージョンでの詳細がわかります。

```shell
php composer.phar show monolog/monolog 1.0.2
```

### オプション

* **--all:** 全てのリポジトリで使える全てのパッケージを一覧にします。
* **--installed (-i):**
  インストールされているパッケージを一覧にします（これは既定で有効になっており、時代遅れのオプションです）。
* **--locked:** composer.lockからロックされたパッケージを一覧にします。
* **--platform (-p):** プラットフォームパッケージ（phpと拡張）のみを一覧にします。
* **--available (-a):** 利用できるパッケージのみにします。
* **--self (-s):** ルートパッケージ情報を一覧にします。
* **--name-only (-N):** パッケージ名のみを一覧にします。
* **--path (-P):** パッケージのパスを一覧にします。
* **--tree (-t):** 依存関係を木構造で一覧にします。パッケージ名を渡した場合はそのパッケージの依存関係を示します。
* **--latest (-l):** インストールされている全てのパッケージをその最新バージョンと共に一覧にします。
* **--outdated (-o):** --latestを暗示しますが、これは新しいバージョンが手に入るパッケージ *のみ* を一覧にします。
* **--ignore:**
  指定されたパッケージを無視します。パッケージの新しいバージョンについてお知らせを受けたくなければ--outdatedオプションと一緒に使ってください。
* **--no-dev:** パッケージ一覧から開発用の依存関係を除外します。
* **--major-only (-M):**
  --latestまたは--outdatedと一緒に使ってください。メジャーなSemVer互換の更新があるパッケージのみ示されます。
* **--minor-only (-m):**
  --latestまたは--outdatedと一緒に使ってください。マイナーなSemVer互換の更新があるパッケージのみ示されます。
* **--patch-only:**
  --latestまたは--outdatedと一緒に使ってください。パッチレベルのSemVer互換の更新があるパッケージのみが示されます。
* **--direct (-D):** パッケージの一覧を直接的な依存関係に限定します。
* **--strict:** 時代遅れのパッケージがあるときは非ゼロの終了コードを返します。
* **--format (-f):** 出力形式としてtext（既定）ないしjsonを選びます。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、たとえローカルマシンがこれらの要件を満たしていなくても、インストールを強行します。--outdatedオプションと一緒に使ってください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、たとえローカルマシンがその要件を満たしていなくても、インストールを強行します。
  ワイルドカードを介して複数の要件を無視できます。
  --outdatedオプションと一緒に使ってください。

## outdated

`outdated`コマンドは、更新が利用できるインストール済みパッケージの一覧を、現在のバージョンと最新のバージョンを含めて示します。これは基本的に`composer
show -lo`の別名になっています。

色彩コードは以下の通り。

- **green (=)**: 依存関係は最新バージョンであり、最新式です。
- **yellow (`~`)**:
  依存関係に新しいバージョンが利用できるものがありますが、セマンティックバージョニングによると後方互換性の破壊が含まれます。
  そのため更新できそうならしても良いですが、作業が発生する可能性があります。
- **red (!)**: 依存関係にはセマンティックバージョニング上互換性のある新しいバージョンがあり更新するべきです。

### オプション

* **--all (-a):** 時代遅れのものだけでなく、全てのパッケージを示します（`composer show --latest`の別名です）。
* **--direct (-D):** パッケージの一覧を直接的な依存関係に限定します。
* **--strict:** 1つもパッケージが時代遅れでなければ非ゼロの終了コードを返します。
* **--ignore:** 指定されたパッケージを無視します。何かしらのパッケージの新しいバージョンについて知らされたくないときに使ってください。
* **--major-only (-M):** メジャーなセマンティックバージョニング上の互換性を伴う更新のみ示します。
* **--minor-only (-m):** マイナーなセマンティックバージョニング上の互換性を伴う更新のみ示します。
* **--patch-only (-p):** パッチレベルのセマンティックバージョニング上の互換性を伴う更新のみ示します。
* **--format (-f):** 出力形式としてtext（既定）ないしjsonを選びます。
* **--no-dev:** 時代遅れの開発用依存関係を表示しません。
* **--locked:** ロックファイルを元にしたパッケージの更新を示します。現時点でベンダーディレクトリに何がインストールされるかは措かれます。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、たとえローカルマシンがこれらの要件を満たしていなくても、インストールを強行します。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`それから`ext-*`）を無視して、たとえローカルマシンが満たしていなかったとしても、インストールを強行します。
  ワイルドカードを使って複数の要件を無視できます。

## browse / home

`browse`（別名`home`）はパッケージのリポジトリURLまたはホームページをブラウザで開きます。

### オプション

* **--homepage (-H):** リポジトリではなくホームページのURLを開きます。
* **--show (-s):** ホームページないしリポジトリのURLを表示するだけにします。

## suggests

現在インストールされているパッケージの集合から提案される全てのパッケージを一覧にします。
おまけとして複数のパッケージ名を`vendor/package`の形式で渡し、これらのパッケージのみについて提案を出力するように制限できます。

`--by-package`（既定）ないし`--by-suggestion`フラグを使って出力をグループ分けできます。それぞれ提案を行うパッケージによるグループ分けと提案されたパッケージによるグループ分けになっています。

提案されたパッケージ名の一覧だけが欲しければ`--list`を使ってください。

### オプション

* **--by-package:** 提案を行ったパッケージによって出力をグループ分けします（既定）。
* **--by-suggestion:** 提案されたパッケージによって出力をグループ分けします。
* **--all:** 推移的なものを含む全ての依存関係から提案を示します（既定では直接的な依存関係の提案のみが示されます）。
* **--list:** 提案されたパッケージ名のみを一覧として示します。
* **--no-dev:** `require-dev`パッケージからの提案を除外します。

## fund

依存関係の維持管理に投資して支える方法を見付けます。
このコマンドはインストールされている依存関係から全ての投資のリンクを一覧にします。
機械が読むことのできる出力を得るには`--format=json`を使ってください。

### オプション

* **--format (-f):** 出力形式としてtext（既定）ないしjsonを選びます。

## depends / why

`depends`コマンドは特定のパッケージに依存する他のパッケージを教えてくれます。インストールの際、`require-dev`の関係はルートパッケージのみ考慮されます。

```shell
php composer.phar depends doctrine/lexer
```
```text
doctrine/annotations  1.13.3 requires doctrine/lexer (1.*)
doctrine/common       2.13.3 requires doctrine/lexer (^1.0)
```

おまけとしてパッケージの後にバージョン制約を指定することで検索結果を絞り込むことができます。

`--tree`や`-t`フラグを加えると、なぜそのパッケージが依存されているのかの再帰的な木構造が示されます。例えば以下の通りです。

```shell
php composer.phar depends psr/log -t
```
```text
psr/log 1.1.4 Common interface for logging libraries
├──composer/composer 2.4.x-dev (requires psr/log ^1.0 || ^2.0 || ^3.0)
├──composer/composer dev-main (requires psr/log ^1.0 || ^2.0 || ^3.0)
├──composer/xdebug-handler 3.0.3 (requires psr/log ^1 || ^2 || ^3)
│  ├──composer/composer 2.4.x-dev (requires composer/xdebug-handler ^2.0.2 || ^3.0.3)
│  └──composer/composer dev-main (requires composer/xdebug-handler ^2.0.2 || ^3.0.3)
└──symfony/console v5.4.11 (conflicts psr/log >=3) (circular dependency aborted here)
```

### オプション

* **--recursive (-r):** 再帰的にルートパッケージまで木構造を解決します。
* **--tree (-t):** 入れ子の木構造を結果に出力します。-rを暗示します。

## prohibits / why-not

`prohibits`コマンドを使うと与えられたパッケージがインストールされる上でどのパッケージが障壁になっているのかがわかります。バージョン制約を指定するとプロジェクトにおいて更新が実施できるかを検証し、もしできなければその理由を示します。以下の例をご覧ください。

```shell
php composer.phar prohibits symfony/symfony 3.1
```
```text
laravel/framework v5.2.16 requires symfony/var-dumper (2.8.*|3.0.*)
```

なおプラットフォーム要件も指定できます。
例えばサーバーをPHP 8.0に更新できるかどうかを確認するにはこうします。

```shell
php composer.phar prohibits php 8
```
```text
doctrine/cache        v1.6.0 requires php (~5.5|~7.0)
doctrine/common       v2.6.1 requires php (~5.5|~7.0)
doctrine/instantiator 1.0.5  requires php (>=5.3,<8.0-DEV)
```

`depends`と同様に再帰的な探索を求めることができます。その場合は競合を起こしているパッケージに依存している全てのパッケージを一覧にします。

### オプション

* **--recursive (-r):** 再帰的にルートパッケージまで木構造を解決します。
* **--tree (-t):** 入れ子の木構造を結果に出力します。-rを暗示します。

## validate

`composer.json`ファイルをコミットしてリリースのタグ付けをする前には常に`validate`コマンドを走らせるべきです。このコマンドは`composer.json`が妥当であることを検査します。

```shell
php composer.phar validate
```

### オプション

* **--no-check-all:**
  `composer.json`中の要件が範囲のないものであったり過度に厳密なバージョン制約であったりする場合について、警告を出しません。
* **--no-check-lock:** `composer.lock`が存在し、更新されていない場合について、警告を出しません。
* **--no-check-publish:**
  Packagistに投稿するには相応しくないがそうでなければ妥当な`composer.json`になっている場合について、エラーを出しません。
* **--with-dependencies:** 全てのインストールされた依存関係についてもcomposer.jsonを検証します。
* **--strict:** エラーに加えて警告についても非ゼロの終了コードを返します。

## status

依存関係のコードを変更したりソースからインストールしたりする必要がしばしばある場合は、`status`コマンドを使うとその中からローカルで加えた変更があるか確認できます。

```shell
php composer.phar status
```

`--verbose`コマンドで変化したところについてのより詳しい情報を得られます。

```shell
php composer.phar status -v
```
```text
You have changes in the following dependencies:
vendor/seld/jsonlint:
    M README.mdown
```

## self-update / selfupdate

Composer自体を最新版に更新したければ`self-update`コマンドを走らせてください。`composer.phar`を最新版に置き換えます。

```shell
php composer.phar self-update
```

そうではなく特定のリリースに更新したければそのように指定してください。

```shell
php composer.phar self-update 2.4.0-RC1
```

Composerをシステム全体にインストールしたときは（[大域的なインストール](00-intro.md#globally)を参照）、コマンドを`root`権限で走らせなくてはならないかもしれません。

```shell
sudo -H composer self-update
```

ComposerがPHARとしてインストールされていなければこのコマンドは使えません（Composerがオペレーティングシステムのパッケージ管理によってインストールされたときはこの場合に当たることがあります）。

### オプション

* **--rollback (-r):** インストールした直近のバージョンに巻き戻します。
* **--clean-backups:**
  更新時に古いバックアップを削除します。更新後は現在のComposerのバージョンのみがバックアップとして残ります。
* **--no-progress:** ダウンロードのプログレスバーを出力しません。
* **--update-keys:** キーの更新をユーザーに尋ねます。
* **--stable:** 更新を安定チャンネルに強制します。
* **--preview:** 更新をプレビューチャンネルに強制します。
* **--snapshot:** 更新をスナップショットチャンネルに強制します。
* **--1:** 更新を安定チャンネルに強制しますが、1.x版のみを使います。
* **--2:** 更新を安定チャンネルに強制しますが、2.x版のみを使います。
* **--set-channel-only:** チャンネルを既定のものとして保存するだけして終了します。

## config

`config`コマンドではローカルの`composer.json`ファイルまたは大域的な`config.json`ファイルにあるComposerの設定やリポジトリを編集できます。

加えてローカルの`composer.json`にあるほとんどのプロパティを編集できます。

```shell
php composer.phar config --list
```

### 使い方

`config [options] [setting-key] [setting-value1] ... [setting-valueN]`

`setting-key`は設定のオプション名で`setting-value1`は設定値です。（`github-protocols`のような）値の配列を取ることができる設定については複数の設定値の引数が可能です。

以下のプロパティの値を編集することもできます。

`description`、`homepage`、`keywords`、`license`、`minimum-stability`、`name`、`prefer-stable`、`type`、そして`version`です。

妥当な設定オプションについては[設定](06-config.md)の章を参照してください。

### オプション

* **--global (-g):**
  既定では`$COMPOSER_HOME/config.json`に位置する大域設定ファイルを編集します。このオプションがなければ、このコマンドはローカルのcomposer.json`ファイルないし`--file`により指定されたファイルに影響します。
* **--editor (-e):**
  ローカルのcomposer.jsonファイルを`EDITOR`環境変数で定義されたテキストエディタを使って開きます。`--global`オプションと一緒に使うと大域設定ファイルを開きます。
* **--auth (-a):** 認証設定ファイルに影響します（--editorの使用限定です）。
* **--unset:** `setting-key`の名前が付いている設定要素を削除します。
* **--list (-l):** 現在の設定変数の一覧を示します。`global`オプションと一緒に使うと大域設定のみを一覧にします。
* **--file="..." (-f):**
  composer.jsonではなく特定のファイルについて編集します。なおこれは`--global`オプションと織り交ぜて使うことはできません。
* **--absolute:** `*-dir`設定値を取得するとき相対パスではなく絶対パスを返します。
* **--json:** 設定値をJSONでデコードします。このデコード結果は`extra.*`キーで使うことができます。
* **--merge:** 設定値を現在の値と統合します。`--json`と組み合わせて`extra.*`キーに使えます。
* **--append:** リポジトリを追加するとき、既存のものの先頭に追加する（最優先）のではなく末尾に付ける（低優先）ようにします。
* **--source:** 設定値がどこから読み込まれたのかを表示します。

### リポジトリを変更する

設定部分を変更することに加えて、`config`コマンドを以下のように使うことでリポジトリ部分を変更することにも対応しています。

```shell
php composer.phar config repositories.foo vcs https://github.com/foo/bar
```

リポジトリにより多くの設定オプションが必要なら、代わりにそのJSON表現を渡すことができます。

```shell
php composer.phar config repositories.foo '{"type": "vcs", "url": "http://svn.example.org/my-project/", "trunk-path": "master"}'
```

### 追加の値を変更する

設定部分を変更することに加えて、`config`コマンドを以下のように使って追加部分を変更することにも対応しています。

```shell
php composer.phar config extra.foo.bar value
```

ドットは入れ子の連なりを表していますが、深さは3段階までです。上は`"extra": { "foo": { "bar": "value" }
}`を設定します。

複雑な値を加えたり変更したりする場合は`--json`や`--merge`フラグを使って追加のフィールドをJSONとして編集できます。

```shell
php composer.phar config --json extra.foo.bar '{"baz": true, "qux": []}'
```

## create-project

Composerを使って既存のパッケージから新しいプロジェクトを作ることができます。これはgit cloneやsvn
checkoutをしてからベンダーにあるものを`composer install`することと等価です。

このコマンドにはいくつかの活用法があります。

1. アプリケーションパッケージをデプロイできます。
2. 任意のパッケージをチェックアウトして、例えばパッチを開発できます。
3. 複数人の開発者がいるプロジェクトでこの機能を使い、開発のための初期のアプリケーションに着手できます。

Composerで新しいプロジェクトを作るためには`create-project`コマンドが使えます。パッケージ名とプロジェクトを作成するディレクトリを渡してください。また、3つ目の引数としてバージョンを与えることもでき、与えない場合は最新版が使われます。

ディレクトリがその時点で存在しなければインストールの過程で作られます。

```shell
php composer.phar create-project doctrine/orm path "2.2.*"
```

プロジェクトに着手するための既存の`composer.json`があるディレクトリ内では、引数がなくともコマンドを走らせることができます。

既定ではコマンドはパッケージをpackagist.orgで確認します。

### オプション

* **--stability (-s):** パッケージの最小安定性です。`stable`が既定です。
* **--prefer-install:** パッケージをダウンロードする方法は2つあり、`source` と`dist`です。
  Composerは`dist`を既定で使います。
  `--prefer-install=source`（または`--prefer-source`）を渡すとComposerはもしあれば`source`からインストールします。
  これはプロジェクトへのバグ修正をして依存関係のローカルgitクローンを直接取得したい場合に便利です。
  Composerがパッケージの開発版用の`source`を自動的に使う過去の挙動にしたければ、`--prefer-install=auto`を使ってください。
  [config.preferred-install](06-config.md#preferred-install)も参照してください。
  このフラグを渡すと設定値より優先されます。
* **--repository:**
  パッケージを探索するための独自のリポジトリを与えます。このリポジトリはpackagistの代わりに使われます。`composer`ディレクトリを指すHTTP
  URLでも、ローカルの`packages.json`ファイルへのパスでも、あるいは[リポジトリ](04-schema.md#repositories)キーが受け付けるものに似たJSON文字列でも大丈夫です。複数回使って複数のリポジトリを設定できます。
* **--add-repository:**
  composer.jsonの中に独自のリポジトリを加えます。ロックファイルが存在している場合、一旦削除されインストールの代わりに更新が走ります。
* **--dev:** `require-dev`に挙げられたパッケージをインストールします。
* **--no-dev:** require-devのパッケージのインストールを無効にします。
* **--no-scripts:** ルートパッケージで定義されているスクリプトの実行を無効にします。
* **--no-progress:** 端末を散らかしかねない進捗表示やバックスペース文字を扱わないスクリプトを除きます。
* **--no-secure-http:**
  ルートパッケージのインストール中、一時的にsecure-http設定オプションを無効にします。自己責任でご利用ください。このフラグを使うのは関心しません。
* **--keep-vcs:**
  作成されるプロジェクトのVCSメタデータの削除を飛ばします。これが役に立つのはコマンドを非対話的なモードで走らせているときがほとんどです。
* **--remove-vcs:** プロンプトなしにVCSメタデータを強制削除します。
* **--no-install:** ベンダーのインストールを無効にします。
* **--no-audit:**
  インストールが完了したあとの監査過程を走らせないようにします。[COMPOSER_NO_AUDIT](#composer-no-audit)も参照してください。
* **--audit-format:** 監査の出力形式です。
  "table"、"plain"、"json"、または"summary"（既定）のどれかでなければなりません。
* **--ignore-platform-reqs:**
  全てのプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、ローカルマシンがたとえこれらを満たしていなくてもインストールを強行します。
  [`platform`](06-config.md#platform)設定オプションも参照してください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`それから`ext-*`）を無視して、たとえローカルマシンが満たしていなかったとしても、インストールを強行します。
  ワイルドカードを使って複数の要件を無視できます。
* **--ask:** 利用者に新しいプロジェクトの対象ディレクトリを入れてもらうようにします。

## dump-autoload / dumpautoload

例えばクラスマップパッケージ中に新しいクラスができたことによって自動読み込み器を更新する必要がある場合は、インストールや更新を行わずとも`dump-autoload`が使えます。

加えて、効率性の理由からPSR-0/4のパッケージをクラスマップのものに変換する最適化された自動読み込み器を吐き出すことができます。多くのクラスがある比較的大規模なアプリケーションでは自動読み込み器は毎回のリクエストに掛かる時間のうち無視できない時間が掛かります。開発時に常にクラスマップを使うことはあまり便利ではありませんが、このオプションを使えば便宜上PSR-0/4を使いつつも効率性のためにクラスマップを使うことができます。

### オプション
* **--optimize (-o):**
  PSR-0/4自動読み込みをクラスマップに変換し、より高速な自動読み込み器を得ます。これは実運用で特に推奨されますが、走らせるのに少し時間が掛かるため現時点では既定で有効になっていません。
* **--classmap-authoritative (-a):**
  クラスマップからのみクラスを自動読み込みします。暗に`--optimize`を有効します。
* **--apcu:** APCuを使ってクラスの有無をキャッシュします。
* **--apcu-prefix:** APCu自動読み込み器のキャッシュに独自の接頭辞を使います。暗に`--apcu`を有効にします。
* **--no-dev:** autoload-dev規則を無効にします。
  既定では、Composerは直近の`install --no-dev`または`update
  --no-dev`の状態に随って自動的にこれを推測します。
* **--dev:** autoload-dev規則を有効にします。
  既定では、Composerは直近の`install --no-dev`または`update
  --no-dev`の状態に随って自動的にこれを推測します。
* **--ignore-platform-reqs:**
  全ての`php`、`hhvm`、`lib-*`、`ext-*`要件を無視し、これらの[プラットフォーム検査](07-runtime.md#platform-check)を飛ばします。[`platform`](06-config.md#platform)設定オプションも参照してください。
* **--ignore-platform-req:**
  特定のプラットフォーム要件（`php`、`hhvm`、`lib-*`、`ext-*`）を無視し、それについての[プラットフォーム検査](07-runtime.md#platform-check)を飛ばします。
  ワイルドカードを使って複数の要件を無視できます。
* **--strict-psr:** PSR-4またはPSR-0の対応付けエラーが存在する場合は失敗の終了コード (1) を返します。
  動作には--optimizeが必要です。

## clear-cache / clearcache / cc

Composerのキャッシュディレクトリから全ての内容を削除します。

### オプション

* **--gc:** ガベージコレクションのみを走らせます。完全なキャッシュの消去は行いません。

## licenses

インストールされている全てのパッケージの名前、バージョン、使用許諾を一覧にします。`--format-json`を使うと機械が読み込みやすい出力が得られます。

### オプション

* **--format:** 出力の形式です。text、json、summaryのいずれかです（既定では「text」）。
* **--no-dev:** 出力から開発依存関係を除きます。

## run-script / run

### オプション

* **--timeout:** スクリプトの制限時間を秒単位で設定します。0は制限時間無しです。
* **--dev:** 開発モードを設定します。
* **--no-dev:** 開発モードを無効にします。
* **--list (-l):** 利用者が定義したスクリプトを一覧にします。

[スクリプト](articles/scripts.md)を手動で走らせるにはこのコマンドを使うことができます。スクリプト名と任意で必要な引数を与えます。

## exec

ベンダーのバイナリやスクリプトを実行します。どんなコマンドも実行できますし、必ずコマンドが走る前にComposerのbin-dirがPATHに加えられます。

### オプション

* **--list (-l):** 利用できるComposerのバイナリを一覧にします。

## diagnose

バグや奇妙な挙動を発見したと思ったら、`diagnose`コマンドを走らせて、多くのよくある問題について自動化された検査を実施できます。

```shell
php composer.phar diagnose
```

## archive

このコマンドを使うと与えられたバージョンの与えられたパッケージについてzip/tarアーカイブを生成します。除外/無視されたファイルのないプロジェクト全体をアーカイブするために使うこともできます。

```shell
php composer.phar archive vendor/package 2.0.21 --format=zip
```

### オプション

* **--format (-f):** アーカイブ結果の形式です。tar、tar.gz、tar.bz2、zipのいずれかです（既定：「tar」）。
* **--dir:** アーカイブをこのディレクトリに書き出します（既定：「.」）。
* **--file:** 与えられたファイル名でアーカイブを書き出します。

## audit

このコマンドを使うとインストールしたパッケージをセキュリティ上の問題があるか監査できます。
[Packagist.org api][api]に従って、セキュリティ上の脆弱性に対する推奨事項を確認して一覧にします。

[api]: https://packagist.org/apidoc#list-security-advisories

auditコマンドは見付かった脆弱性の量を返します。
成功時は`0`を、それ以外は最大`255`の数を返します。

```shell
php composer.phar audit
```

### オプション

* **--no-dev:** require-devのパッケージの監査を無効にします。
* **--format (-f):**
  出力の形式を監査します。監査の出力は「table」（既定）、「plain」、「json」、「summary」の何れかです。
* **--locked:** ロックファイルのパッケージを監査します。現時点でベンダーディレクトリに何があるかは無視されます。

## help

あるコマンドについて詳細が知りたければ`help`が使えます。

```shell
php composer.phar help install
```

## コマンドラインインターフェース

コマンドライン補完は[このページにある](https://github.com/bamarni/symfony-console-autocomplete)説明に従って有効にできます。

## 環境変数

環境変数を設定して多くの設定を上書きできます。
できる限りこうした設定は環境変数ではなく`composer.json`の`config`部分で指定することをお勧めします。
環境変数は`composer.json`で指定された値より常に優先されるということ以外に利点はありません。

### COMPOSER

`COMPOSER`環境変数を設定することにより`composer.json`のファイル名を何か別のものに設定できます。

例えば：

```shell
COMPOSER=composer-other.json php composer.phar install
```

生成されるロックファイルは同じ名前を使います。この例では`composer-other.lock`です。

### COMPOSER_ALLOW_SUPERUSER

1に設定するとこの環境変数はコマンドをルートないしスーパーユーザーとして走らせることについての警告を無効にします。自動的なsudoセッションの消去も無効にするため、必ずDockerコンテナのような常時スーパーユーザーとしてComposerを使うときにのみ設定するようにしてください。

### COMPOSER_ALLOW_XDEBUG

1に設定すると、Xdebug拡張を持たないPHPを再始動させることなく、環境変数はXdebug拡張が有効のときにComposerを走らせられるようにします。

### COMPOSER_AUTH

`COMPOSER_AUTH`変数では、環境変数として認証を設定できます。
変数の内容はJSON形式のオブジェクトで、[http-basic、github-oauth、bitbucket-oauth、……といった必要に応じたもの][auth]です。
オブジェクトは[設定の仕様](06-config.md)に従います。

[auth]: articles/authentication-for-private-packages.md

### COMPOSER_BIN_DIR

このオプションを設定すると`bin`ディレクトリ（[ベンダーバイナリ](articles/vendor-binaries.md)）を`vendor/bin`とは違う別のどこかに変更できます。

### COMPOSER_CACHE_DIR

`COMPOSER_CACHE_DIR`変数ではComposerのキャッシュディレクトリを変更できます。
これは[`cache-dir`](06-config.md#cache-dir)オプションを介しても設定できます。

Windowsにおいて既定では`C:\Users\<user>\AppData\Local\Composer`（もしくは`%LOCALAPPDATA%/Composer`）を指します。
\*nixシステムでは[XDG Base Directory Specifications][xdg]に従い、`$XDG_CACHE_HOME/composer`を指します。他の\*nixシステムとmacOSにおいては`$COMPOSER_HOME/cache`を指します。

[xdg]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

### COMPOSER_CAFILE

この環境値を設定することで、パスを証明書バンドルファイルに設定してSSL/TLSピア検証で使えるようにします。

### COMPOSER_DISABLE_XDEBUG_WARN

1に設定すると、ComposerがXdebug拡張が有効の状態で走っているときに出す警告をこの環境変数により抑制します。

### COMPOSER_DISCARD_CHANGES

この環境変数は[`discard-changes`](06-config.md#discard-changes)設定オプションを制御します。

### COMPOSER_HOME

`COMPOSER_HOME`変数によりComposerのホームディレクトリを変えられます。これは全てのプロジェクトで共有される、隠された（マシン上の使用者毎の）大域的なディレクトリです。

`composer config --global home`を使ってホームディレクトリの場所を確認してください。

既定では、Windowsにおいては`C:\Users\<user>\AppData\Roaming\Composer`を、macOSにおいては`/Users/<user>/.composer`を指します。\*nixシステムでは[XDG Base Directory Specifications][xdg]に従い、`$XDG_CONFIG_HOME/composer`を指します。他の\*nixシステムでは`/home/<user>/.composer`を指します。

[xdg]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

#### COMPOSER_HOME/config.json

`config.json`ファイルを`COMPOSER_HOME`が指す場所に置くことができます。Composerは`install`及び`update`コマンドを走らせたとき、部分的に（`config`および`repositories`キーのみ）この設定をプロジェクトの`composer.json`と統合します。

このファイルがあれば使用者のプロジェクト用に[リポジトリ](05-repositories.md)と[構成](06-config.md)を設定できます。

大域的な設定が _ローカルの_ 設定に合致した場合、プロジェクトの`composer.json`が常に優先されます。

### COMPOSER_HTACCESS_PROTECT

既定では`1`です。`0`に設定するとComposerはComposerのホーム、キャッシュ、データディレクトリに`.htaccess`ファイルを作りません。

### COMPOSER_MEMORY_LIMIT

設定すると、その値がphpのメモリ上限として使われます。

### COMPOSER_MIRROR_PATH_REPOS

1に設定すると、この環境変数は既定のパスリポジトリ戦略を`symlink`ではなく`mirror`に変更します。既定の戦略が設定されているため、リポジトリオプションで上書きすることもできます。

### COMPOSER_NO_INTERACTION

1に設定すると、この環境変数によりComposerがあたかも全てのコマンドについて`--no-interaction`フラグを渡されたかのように動作します。これはbuild
box/CIで設定できます。

### COMPOSER_PROCESS_TIMEOUT

この環境変数はコマンド（例えばgitコマンド）が実行終了するまでの待機時間を制御します。既定値は300秒（5分）です。

### COMPOSER_ROOT_VERSION

この変数を設定することで、ルートパッケージのバージョンがVCSの情報から推測できず、`composer.json`にもないときに、そのバージョンを指定できます。

### COMPOSER_VENDOR_DIR

この変数を設定することでComposerに依存関係を`vendor`以外のディレクトリにインストールさせられます。

### COMPOSER_RUNTIME_ENV

これによりどの環境でComposerが走っているのかの手掛かりが得られ、Composerで何らかの環境特有の問題を回避するための助けになります。
現在対応している唯一の値は`virtualbox`で、こうするといくつかの短い`sleep()`呼び出しを有効にして、ファイルシステムが適切にファイルに書き込むのを待ってからそのファイルを読み込むようにします。
VagrantやVirtualboxを使っていてファイルが存在しているのにも関わらずインストール時にファイルがない旨問題に遭遇したときは、この環境変数を設定すると良いでしょう。

### http_proxyやHTTP_PROXY

ComposerをHTTPプロキシの背後から使っている場合、標準的な`http_proxy`や`HTTP_PROXY`環境変数を使うことができます。変数はプロキシのURLに設定してください。多くのオペレーティングシステムは既にこの変数を設定してくれています。

gitやcurlのようなツールが小文字の`http_proxy`版のみを使っているために、`http_proxy`（小文字）を使ったり両方とも定義するすることが良いこともあるでしょう。
代替案として`git config --global http.proxy <proxy url>`を使ってgitのプロキシを定義することもできます。

ComposerをCLIの文脈で使っておらず、プロキシの対応が必要であれば、代替として`CGI_HTTP_PROXY`環境変数を与えてください。詳細は[httpoxy.org](https://httpoxy.org/)を参照してください。

### COMPOSER_MAX_PARALLEL_HTTP

整数を指定し、並列で何個のファイルをダウンロードするか設定します。これは既定で12になっており、1から50の間でなければいけません。プロキシに並列性の問題があるときはこの値を下げたいかもしれません。この値を増加させても一般には効率性が上がる結果にはならないでしょう。

### HTTP_PROXY_REQUEST_FULLURI

プロキシを使っているものの、request_fulluriフラグに対応していなければ、この環境変数を`false`や`0`に設定してComposerがrequest_fulluriオプションを設定するのを防ぐと良いでしょう。

### HTTPS_PROXY_REQUEST_FULLURI

プロキシを使っているが、HTTPSリクエストについてrequest_fulluriに対応していなければ、この環境変数を`false`や`0`に設定してComposerがrequest_fulluriオプションを設定するのを防ぐと良いでしょう。

### COMPOSER_SELF_UPDATE_TARGET

設定した場合、self-updateコマンドが元あるファイルではなく与えられたパスに新しいComposerのpharファイルを書き込むようにします。読み込み専用のファイルシステムでComposerを更新するときに便利です。

### no_proxyやNO_PROXY

プロキシの背後にあって特定のドメインを無効にしたい場合は、`no_proxy`または`NO_PROXY`環境変数を使うことができます。プロキシが使われ*ない*ドメインのコンマ区切りリストを設定します。

環境変数はCIDR記法でドメイン、IPアドレス、IPアドレスブロックを受け付けます。
フィルタを特定のポートに制限できます（例：`:80`）。
`*`を設定して全てのHTTPリクエストについてプロキシを無効にもできます。

### COMPOSER_DISABLE_NETWORK

`1`に設定するとネットワークアクセスを（最大限の努力で）無効にします。この変数はComposerをデバッグしたり貧弱な接続環境下で走らせたりするのに使えます。

`prime`に設定した場合、GitHub VCSリポジトリはキャッシュに前もって溜め込んでおくため、`1`で完全にオフラインで使えるようになります。

### COMPOSER_DEBUG_EVENTS

`1`に設定するとディスパッチされたイベントについての情報を出力します。プラグインの作者にとって何が厳密にどの時点で発火しているのか特定するのに便利かもしれません。

### COMPOSER_NO_AUDIT

`1`に設定すると、`require`、`update`、`remove`、`create-project`コマンドに`--no-audit`コマンドを渡すことと等価になります。

### COMPOSER_NO_DEV

`1`に設定すると`--update-no-dev`を`require`に渡したり`install`、`update`に`--no-dev`オプションを渡すのと等価になります。
`COMPOSER_NO_DEV=0`を設定することで1回のコマンドについてこの設定を上書きできます。

### COMPOSER_PREFER_STABLE

`1`に設定すると`update`や`require`に`--prefer-stable`オプションを渡すことと等価になります。

### COMPOSER_PREFER_LOWEST

`1`に設定すると`update`や`require`に`--prefer-lowest`オプションを渡すことと等価になります。

### COMPOSER_IGNORE_PLATFORM_REQやCOMPOSER_IGNORE_PLATFORM_REQS

`COMPOSER_IGNORE_PLATFORM_REQS`を`1`に設定すると、`--ignore-platform-reqs`引数を渡すことと等価になります。他方で`COMPOSER_IGNORE_PLATFORM_REQ`でコンマ区切りのリストを指定するとこれらの特定の要件を無視します。

例えば開発ワークステーションが全くデータベースクエリを走らせない場合、データベースの要件が利用できることの要件を無視するのに使うことができます。`COMPOSER_IGNORE_PLATFORM_REQ=ext-oci8`を設定すると、Composerは`oci8`PHP拡張が有効になっていなくともパッケージをインストールします。

&larr; [ライブラリ](02-libraries.md)  | [スキーマ](04-schema.md) &rarr;
