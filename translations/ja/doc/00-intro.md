# 導入

ComposerはPHPの依存管理ツールです。
Composerはプロジェクトが依存するライブラリを宣言し管理（インストールやアップデート）できるようにするものです。

## 依存管理

ComposerはYumやAptの伝で言うとパッケージ管理ツールでは**ありません**。
「パッケージ」やライブラリを扱いはしますが、プロジェクト毎の管理であって、プロジェクトの内部のディレクトリ（例：`vendor`）にインストールするのです。
既定では決して大域的にインストールしません。
したがって、依存管理なわけです。
とはいえ便宜上[global](03-cli.md#global)コマンドを介して「大域的な」プロジェクトに対応してはいます。

このアイデアは新しいものではありません。
Composerはnodeの[npm](https://www.npmjs.org/)やrubyの[bundler](https://bundler.io/)に強く影響を受けています。

想像してみてください。

1. 大量のライブラリに依存したプロジェクトがある。
2. 別のライブラリに依存するライブラリがある。

Composerでは次のことができます。

1. 依存するライブラリを宣言できる。
2. どのパッケージのどのバージョンをインストールする必要があるのかを調べて、インストールする（つまりプロジェクト内にパッケージをダウンロードします）。
3. 1つのコマンドで全ての依存関係を更新できます。

依存関係の宣言についての詳細は[基本的な使い方](01-basic-usage.md)の章を参照してください。

## システム要件

最新のComposerが動作するためにはPHP 7.2.5が必要です。
歴史的なPHPのバージョンで止まっている場合は長期サポート版 (2.2.x) がまだPHP 5.3.2以上に対応しています。
また、いくつかの細かいPHPの設定とコンパイルフラグも必要ですが、要件が合っていない箇所については、インストーラが警告を出すでしょう。

Composerが効率的に動作するには、幾つかの補助的なアプリケーションが必要です。
これらはパッケージの依存関係を扱う処理をより効率的にするものです。
ファイルを解凍するために、Composerは`7z`（或いは`7zz`）、`gzip`、`tar`、`unrar`、`unzip`、`xz`のようなツールに依っています。
バージョン管理システムについては、ComposerはFossil、Git、Mercurial、Perforce、Subversionと間断なく協調し、これにより円滑なアプリケーションの操作とライブラリのリポジトリの管理を確実にします。
Composerを使う前にこれらの依存関係が正しくシステムにインストールされていることをご確認ください。

Composerはマルチプラットフォームであり、Windows、Linux、macOSのそれぞれで同じように動作するよう努めています。

## Linux / Unix / macOSへのインストール

### 実行形式のComposerをダウンロード

Composerには便利なインストーラがあり、コマンドラインから直接実行できます。
気兼ねなく[このファイルをダウンロード](https://getcomposer.org/installer)したり、インストーラの内部のはたらきについてもっと知りたいと思ったら[GitHub](https://github.com/composer/getcomposer.org/blob/main/web/installer)で確認したりしてください。
ソースは単なるPHPです。

平たく言うとComposerのインストールには2つの方法があります。
プロジェクトへローカルに入れる方法と、システム全域の実行ファイルとしてグローバルに入れる方法です。

#### ローカル

Composerをローカルにインストールするためには、プロジェクトのディレクトリでインストーラを走らせてください。
解説は[ダウンロードページ](https://getcomposer.org/download/)を参照してください。

インストーラははいくつかのPHPの設定内容を確認して、`composer.phar`を作業ディレクトリにダウンロードします。
このファイルはComposerのバイナリです。
PHAR (PHP archive) はPHPのためのアーカイブ形式であり、コマンドラインから実行できますし、他の方法もあります

ここでComposerを走らせるには`php composer.phar`としてください。

`--install-dir`オプションを使って特定のディレクトリに、更に`--filename`オプションを使って命名（改名）しつつ、Composerをインストールできます。
[ダウンロードページの説明](https://getcomposer.org/download/)に従ってインストーラを走らせるときは、以下の引数を加えてください。

```shell
php composer-setup.php --install-dir=bin --filename=composer
```

それから、`php bin/composer`とするとComposerが走ります。

#### 大域的に使う

Composer PHARは好きな場所に置くことができます。
`PATH`の通った場所に置くことで大域的にアクセスできます。
Unix系のシステムでは実行形式にして`php`インタプリタを直接使わずに呼び出すこともできます。

[ダウンロードページの説明](https://getcomposer.org/download/)に従ってインストーラを走らせた後は、以下を走らせてパスにあるディレクトリにcomposer.pharを移動させられます。

```shell
mv composer.phar /usr/local/bin/composer
```

利用者のためだけにインストールしてルート権限を避けたいようでしたら、代わりに`~/.local/bin`を使うこともできます。
Linuxディストリビューションでは既定で使えることがあります。

> **注意:** 上記がパーミッションによって失敗する場合、sudoで改めて実行する必要があるかもしれません。

> **補足：** macOSのバージョンによって、既定では`/usr`ディレクトリが存在しないことがあります。
> エラー「/usr/local/bin/composer: No such file or directory」が出たら、予め`mkdir -p /usr/local/bin`としてディレクトリを手作りしなければなりません。

> **補足：** パスを変えることに関しては[Wikipediaの記事](https://en.wikipedia.org/wiki/PATH_(variable))を読んだりお好みの検索エンジンに掛けてみてください。

これで`php composer.phar`の代わりに`composer`とすれば、Composerが走るようになりました。

## Windowsへインストール

### インストーラを使う

Composerをマシンに用意する最も簡単な方法です。

[Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe)をダウンロードして実行してください。
最新バージョンのComposerがインストールされパスが設定されるため、どのディレクトリからも`composer`をコマンドラインから呼ぶことができます。

> **補足：** 現在の端末を閉じてください。
新しい端末で使えるか試してみてください。
パスは端末が起動したときにのみ読み込まれるので、一旦閉じるのは大事です。

### 手動でインストール

`composer.phar`をダウンロードするため、`PATH`の通っているディレクトリに移動して[ダウンロードページの説明](https://getcomposer.org/download/)に従い、インストーラを走らせてください。

`composer.bat`ファイルを`composer.phar`と同じ場所に新規作成してください。

cmd.exeを使う場合：

```shell
C:\bin> echo @php "%~dp0composer.phar" %*>composer.bat
```

PowerShellを使う場合：

```shell
PS C:\bin> Set-Content composer.bat '@php "%~dp0composer.phar" %*'
```

まだPATH環境変数にディレクトリがなければ追加してください。
PATH変数を変えることに関しては[この記事](https://www.computerhope.com/issues/ch000549.htm)を参照したりお好みの検索エンジンに掛けてみたりしてください。

現在の端末を閉じてください。
新しい端末で使えるか試してください。

```shell
C:\Users\username>composer -V
```
```text
Composer version 2.4.0 2022-08-16 16:10:48
```

## Dockerイメージ

Composerはいくつかの場所でDockerコンテナとして公開されています。
[composer/dockerのREADME](https://github.com/composer/docker)で一覧を参照してください。

使用例：

```shell
docker pull composer/composer
docker run --rm -it -v "$(pwd):/app" composer/composer install
```

既存の**Dockerfile**にComposerを加えるには、単に既にビルドされた小さいサイズのイメージからバイナリファイルを複製できます。

```Dockerfile
# 最新リリース
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# 特定のリリース
COPY --from=composer/composer:2-bin /composer /usr/bin/composer
```

さらなる使い方の情報については[イメージの説明](https://hub.docker.com/r/composer/composer)をお読みください。

**補足：** Docker固有の問題は[composer/dockerリポジトリ](https://github.com/composer/docker/issues)に報告されると良いでしょう。

**補足：** 上のイメージ名では`composer/composer`の代わりに`composer`を使うこともできます。
名前が短かく、Dockerの公式イメージですが、直接私達が公開したものではないので新しいリリースが数日送れで来ることが普通です。
**重要**：短い別名が付けられたイメージにはバイナリのみの同じものがないため、`COPY --from`の方法については`composer/composer`のほうを使う方が良いです。

## Composerを使う

これでComposerをインストールしたので使う準備ができました。
簡単な実演があるので次の章に向かいましょう。

[基本的な使い方](01-basic-usage.md) &rarr;
