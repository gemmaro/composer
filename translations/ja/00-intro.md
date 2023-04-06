# 導入

ComposerはPHPの依存管理ツールです。
Composerはプロジェクトが依存するライブラリを宣言し管理（インストールやアップデート）できるようにするのです。

## 依存管理

ComposerはYumやAptの伝で言うとパッケージ管理ツールではありません。
まあ、「パッケージ」やライブラリを扱いはしますが、プロジェクト毎の管理であって、プロジェクトの内部のディレクトリ（例：`vendor`）にインストールするのです。
既定では大域的には決してインストールしません。
したがって、これは依存管理なわけです。
とはいえ便宜上[global](03-cli.md#global)コマンドを介して「大域的な」プロジェクトに対応してはいます。

このアイデアは新しいものではありません。
Composerはnodeの[npm](https://www.npmjs.org/)やrubyの[bundler](https://bundler.io/)に強く影響を受けています。

想像してみてください。

1. 大量のライブラリに依存したプロジェクトがある。
2. 別のライブラリに依存するライブラリがある。

Composerでは次のことができます。

1. 依存するライブラリを宣言することができる。
2. どのパッケージのどのバージョンをインストールする必要があるのかを調べて、インストールする（つまりプロジェクト内にパッケージをダウンロードします）。
3. 1つのコマンドで全ての依存関係を更新できます。

依存関係の宣言についての詳細は[基本的な使い方](01-basic-usage.md)の章を参照してください。

## システム要件

最新のComposerが動作するためにはPHP 7.2.5が必要です。
歴史的なPHPのバージョンで止まっている場合は長期サポート版 (2.2.x) がまだPHP 5.3.2以上に対応しています。
また、いくつかの細かいPHPの設定とコンパイルフラグも必要ですが、要件を合っていない箇所については、インストーラが警告を出すでしょう。

単純なzipアーカイブではなくソースからパッケージをインストールするには、パッケージのバージョン管理方法によってgit、svn,
fossilまたはhgが必要です。

Composerはマルチプラットフォームであり、Windows、Linux、macOSのそれぞれで同じように動作するよう努めています。

## Linux / Unix / macOSへのインストール

### 実行形式のComposerをダウンロード

Composerには便利なインストーラがあり、コマンドラインから直接実行できます。
気兼ねなく[このファイルをダウンロード](https://getcomposer.org/installer)したり、またはインストーラの内部のはたらきについてもっと知りたいと思ったら[GitHub](https://github.com/composer/getcomposer.org/blob/main/web/installer)で確認したりしてください。
ソースは単なるPHPです。

平たく言うとComposerのインストールには2つの方法があります。
プロジェクトにローカルに入れる方法と、システム全域の実行ファイルとしてグローバルに入れる方法です。

#### ローカル

Composerをローカルにインストールするためには、プロジェクトのディレクトリでインストーラを走らせてください。
解説は[ダウンロードページ](https://getcomposer.org/download/)を参照してください。

インストーラははいくつかのPHPの設定内容を確認して、`composer.phar`を作業ディレクトリにダウンロードします。
このファイルはComposerのバイナリです。
PHAR (PHP archive) はPHPのためのアーカイブ形式であり、コマンドラインから実行することができますし、他の方法もあります

ここでComposerを走らせるには`php composer.phar`としてください。

`--install-dir`オプションを使って特定のディレクトリに、さらに`--filename`オプションを使って名前を付け（変え）たりしつつ、Composerをインストールすることができます。
[ダウンロードページの説明](https://getcomposer.org/download/)にしたがってインストーラを走らせるときは以下の引数を加えてください。

```shell
php composer-setup.php --install-dir=bin --filename=composer
```

それではComposerを走らせるために`php bin/composer`としてください。

#### グローバル

Composer PHARは好きな場所に置くことができます。
`PATH`の通った場所に置くことで、グローバルにアクセスすることができます。
Unix系のシステムでは実行形式にして`php`インタプリタを直接使わずに呼び出すこともできます。

[ダウンロードページの説明](https://getcomposer.org/download/)にしたがってインストーラを走らせたあとは、以下を走らせてパスにあるディレクトリにcomposer.pharを移動させられます。

```shell
mv composer.phar /usr/local/bin/composer
```

ユーザーのためだけにインストールしルート権限を避けたいようでしたら、代わりにLinuxディストリビューションで既定で使うことができることがある`~/.local/bin`を使うこともできます。

> **注意:** 上記がパーミッションによって失敗する場合、sudoで改めて実行する必要があるかもしれません。

> **補足：** macOSのバージョンによっては既定では`/usr`ディレクトリが存在しないことがあります。
> エラー「/usr/local/bin/composer: No such file or directory」が出たら進める前に`mkdir -p /usr/local/bin`としてディレクトリを手作りしなければなりません。

> **補足：** パスを変えることに関しては[Wikipediaの記事](https://en.wikipedia.org/wiki/PATH_(variable))を読んだりお好みの検索エンジンに掛けてみてください。

それではComposerを走らせるために`php composer.phar`の代わりに`composer`としてください。

## Windowsへインストール

### インストーラを使う

これはComposerをマシンにセットアップする最も簡単な方法です。

[Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe)をダウンロードして実行してください。
最新バージョンのComposerがインストールされパスが設定されるため、どのディレクトリからも`composer`をコマンドラインから呼ぶことができます。

> **補足：** 現在のターミナルを閉じてください。
新しいターミナルで使えるか試してみてください。
パスはターミナルが始まったときのみ読み込まれるので一旦閉じるのは大事です。

### 手動でインストール

`composer.phar`をダウンロードするために`PATH`の通っているディレクトリに移動して[ダウンロードページの説明](https://getcomposer.org/download/)にしたがってインストーラを走らせてください。

新しく`composer.bat`ファイルを`composer.phar`と同じ場所に作成してください。

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

現在のターミナルを閉じてください。
新しいターミナルで使えるかテストします。

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

既存の**Dockerfile**にComposerを加えるには、単に既にビルドされた小さいサイズのイメージからバイナリファイルを複製することができます。

```Dockerfile
# 最新リリース
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# 特定のリリース
COPY --from=composer/composer:2-bin /composer /usr/bin/composer
```

さらなる使い方の情報については[イメージの説明](https://hub.docker.com/r/composer/composer)をお読みください。

**Note:** Docker固有の問題は[composer/dockerリポジトリ](https://github.com/composer/docker/issues)に報告されるとよいでしょう。

**補足：** 上のイメージ名では`composer/composer`の代わりに`composer`を使うこともできます。
名前が短かくDockerの公式イメージですが直接私達が公開したものではないので新しいリリースが数日送れで来ることが普通です。
**重要**：短く別名が付けられたイメージにはバイナリのみの同じものがないため、`COPY --from`の方法については`composer/composer`のほうを使う方がよいです。

## Composerを使う

これでComposerをインストールしたので使う準備ができました。
簡単な実演があるので次の章に向かいましょう。

[基本的な使い方](01-basic-usage.md) &rarr;

- - -

<small>

本和訳にあたっての著作権表示を以下に示します。

Copyright (C) 2013--2015 kohkimakimoto.<br>
Copyright (C) 2022, 2023 gemmaro.

この翻訳は[kohkimakimoto](https://github.com/kohkimakimoto)氏による翻訳を元に改変を加えています。
同氏の翻訳リポジトリは[`kohkimakimoto/getcomposer.org_doc_jp`](https://github.com/kohkimakimoto/getcomposer.org_doc_jp)に、Webサイトは[『Composer ドキュメント日本語訳』の「はじめに」](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/00-intro.html)にあります。
翻訳されていた範囲は以下の通りです。

* [イントロダクション](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/00-intro.html)
* [基本的な使い方](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/01-basic-usage.html)
* [ライブラリ](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/02-libraries.html)
* [コマンドラインインターフェース](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/03-cli.html)のうち、「install」節の「オプション」小節まで。
* [composer.json](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/04-schema.html)の冒頭。
* [コミュニティ](https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/06-community.html)

本翻訳は上記既訳を最新版に追従することを目的としています。
そのため既訳の修正に加えて新規に追加された原文への訳が含まれます。
本翻訳も原文にしたがい、[MITライセンス](https://github.com/composer/composer/blob/main/LICENSE)の下に使用が許諾されます。

</small>
