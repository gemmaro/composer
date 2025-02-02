# ライブラリ

この章ではライブラリをComposerでインストールできるようにする方法を学びます。

## 全てのプロジェクトはパッケージである

`composer.json`をディレクトリに配置した時点で、そのディレクトリはパッケージとなります。
[`require`](04-schema.md#require)をプロジェクトに追加すると、他のパッケージに依存したパッケージを作っていることになります。
プロジェクトとライブラリの唯一の違いは、プロジェクトは名前のないパッケージだということです。

インストール可能なパッケージを作成するためには命名する必要があります。
`composer.json`に[`name`プロパティ](04-schema.md#name)を追加してください。

```json
{
    "name": "acme/hello-world",
    "require": {
        "monolog/monolog": "1.0.*"
    }
}
```

この例では、プロジェクト名は`acme/hello-world`です。
`acme`はベンダー名です。
ベンダー名を与えることは必須です。

> **注意：**
> もしベンダー名に何をつけていいか分からない場合は、大抵は自分のGitHubの利用者名をつけるといいでしょう。
> パッケージ名は全て小文字でなければならず、単語の区切りはダッシュにするのが慣習です。

## ライブラリのバージョン

まず間違いなくgit, svn, hg, fossilといった何らかの類のバージョン管理システムを使ってライブラリを管理することでしょう。
こうした場合、ComposerはVCSからバージョンを推定するので`composer.json`ファイルではバージョンを指定すべきでは**ありません**（ComposerがVCSのブランチとタグを使ってバージョン制約を解決する方法について学ぶためには[バージョンについての記事](articles/versions.md)を参照してください）。

パッケージの管理を手作業でしている（つまりVCS無しの）場合、`composer.json`ファイルに`version`値を加えて、バージョンを明示的に指定する必要があるでしょう。

```json
{
    "version": "1.0.0"
}
```

> **補足：** VCSに埋め込まれているバージョンを加えた場合、バージョンはタグ名と干渉することでしょう。
そうするとComposerはバージョン値を決定できなくなります。

### VCSのバージョン管理

ComposerはVCSのブランチとタグの機能を使って[`require`](04-schema.md#require)フィールドで指定したバージョン制約を特定のファイルの集まりに至るまで解決します。
利用できる妥当なバージョンを決定する際、Composerは全てのタグとブランチを見て、それらの名前を内部的なオプションの一覧に翻訳し、それから与えられたバージョン制約に対して照合します。

Composerがタグとブランチを扱う方法とパッケージのバージョン制約を解決する方法についての詳細は、[バージョン](articles/versions.md)の記事をお読みください。

## 固定ファイル

お望みならライブラリに`composer.lock`ファイルをコミットできます。
チームが常に同じ依存バージョンでテストする際の助けになります。
しかし、この固定ファイルはこれに依存している他のプロジェクトにいかなる影響も齎しません。
主眼のプロジェクトのみに影響します。

もし固定ファイルをコミットしたくなくて、且つgitを使っている場合は、`.gitignore`に追加してください。

## VCSに公開する

`composer.json`ファイルを含むVCSリポジトリ（バージョン管理システム、例えばgit）があれば、ライブラリは既にcomposerでインストール可能です。
この例ではGitHubで`acme/hello-world`ライブラリを`github.com/username/hello-world`として公開するとしましょう。

それでは`acme/hello-world`パッケージのインストールを試すために、ローカルに新しいプロジェクトを作成しましょう。
私たちはそれを`acme/blog`と呼ぶことにします。
このブログは`acme/hello-world`に依存し、更に`monolog/monolog`に依存するとします。
以下の`composer.json`を含む新しい`blog`ディレクトリを作成することで達成されます。

```json
{
    "name": "acme/blog",
    "require": {
        "acme/hello-world": "dev-master"
    }
}
```

名前はこの場合必須ではありません。
このブログをライブラリとして公開することはないからです。
ここではどの`composer.json`が説明されているのかを明確にするために加えられています。

このブログアプリに依存物`hello-world`の所在を知らせる必要があります。
これにはパッケージのリポジトリ指定をこのブログの`composer.json`に追加します。

```json
{
    "name": "acme/blog",
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/username/hello-world"
        }
    ],
    "require": {
        "acme/hello-world": "dev-master"
    }
}
```

パッケージリポジトリの挙動や他にどのようなタイプが利用できるかについての詳細は、[リポジトリ](05-repositories.md)を参照してください。

これで全てです。
Composerの[`install`](03-cli.md#install)コマンドを実行すれば依存関係をインストールできます！

**まとめ：**
`composer.json`を含むあらゆるgit/svn/hg/fossilリポジトリは、[`require`](04-schema.md#require)フィールドでパッケージリポジトリを指定して依存関係を宣言することで、プロジェクトに追加できます。

## Packagistに公開する

よろしい、今やパッケージを公開できるようになりました。
しかし、毎回VCSリポジトリを指定するのは厄介なことです。
全ての利用者にそんなことはさせたくないでしょう。

`monolog/monolog`のためのパッケージリポジトリを指定しなかったこととにお気付きかもしれません。
どのような仕組みなのでしょうか？
答えはPackagistです。

[Packagist](https://packagist.org/)はComposerの主眼のパッケージリポジトリで、 既定で有効になっています。
Packagistで公開されている全てのものは自動的にComposerで利用可能です。
[monologはPackagistにある](https://packagist.org/packages/monolog/monolog)ので、追加のリポジトリ指定なくして依存できるのです。

`hello-world`を世界に共有したければ、同様にPackagistに公開するのが良いでしょう。

[Packagist](https://packagist.org)を開いて"Submit"ボタンを押します。
まだサインアップしていなかったらその旨の表示がされます。
それからVCSリポジトリのURLを送信できます。
送信した時点でPackagistはクローリングを始めます。
完了すると、パッケージは誰でも使えるようになります！

## 軽量配布パッケージ

有用でない情報は普通、配布パッケージに含めない方が良いでしょう。
これには`.github`ディレクトリ、嵩張る例、テストデータなどがあります。

`.gitattributes`ファイルは`.gitignore`のようなgit固有のファイルです。
またライブラリの根幹ディレクトリにあります。
これが存在してgitで追跡されているとき、局所的な構成と大域的な構成（それぞれ`.git/config`と`~/.gitconfig`）がオーバーライドされます。

zipの配布パッケージが肥大化させる望ましくないファイルが入らないようにするには、`.gitattributes`を使ってください。

```text
// .gitattributes
/demo export-ignore
phpunit.xml.dist export-ignore
/.github/ export-ignore
```

生成されたzipファイルを手作業で調べて確認するには、次のようにします。

```shell
git archive branchName --format zip -o file.zip
```

> **補足：**
> ファイルはgitで追跡されたままであり、zipの配布物に含まれていないだけです。
> これはdist（タグ付けされたリリース）でインストールしたパッケージでのみ機能します。
> 配布元はGitHub、GitLab、BitBucketがあります。

&larr; [基本的な使い方](01-basic-usage.md) |  [コマンドラインインターフェース](03-cli.md) &rarr;
