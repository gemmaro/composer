# リポジトリ

この章ではパッケージとリポジトリの概念、利用できるリポジトリの種類に何があるか、そしてどういう仕組みになっているのかを解説します。

## 概念

存在するリポジトリのそれぞれの種別を見ていく前に、Composerが立脚する基礎概念を理解する必要があります。

### パッケージ

Composerは依存関係管理ツールです。パッケージをローカルにインストールします。パッケージは本質的には何かを含むディレクトリです。この場合はその何かがPHPのコードですが、理論上何でもよいわけです。そしてパッケージの名前とバージョンを持つパッケージの説明を含みます。名前とバージョンはパッケージを特定するのに使われます。

実際、内部的にはComposerはそれぞれのバージョンを個別のパッケージとして見做します。
この区別はComposerを使っているときは問題になりませんが、変更したいと思ったときはかなり重要になります。

名前とバージョンに加えて有用なメタデータがあります。インストールに最も関係する情報はソースの定義で、どこかでパッケージの内容を取得するのかを記述します。パッケージのデータはパッケージの内容を指します。そしてここで2つの選択肢があります。distとsourceです。

**Dist:** distはパッケージデータのパッケージ化されたバージョンです。大抵はリリースバージョンで、中でも大抵は安定リリースです。

**Source:** ソースは開発に使われます。
これは大抵gitのようなソースコードリポジトリを起源とします。
ダウンロードされたパッケージを変更したいときはこれを取得できます。

パッケージはこれらのいずれか、または両方を与えることができます。ユーザーにより与えられたオプションやパッケージの安定性などの何らかの要因により、どちらかが相応ということになるでしょう。

### リポジトリ

リポジトリはパッケージソースで、パッケージとバージョンのリストです。Composerは全てのリポジトリを見て回りプロジェクトに必要なパッケージを見付けてきます。

既定ではPackagist.orgリポジトリがComposerに登録されています。`composer.json`に宣言することでプロジェクトにもっとリポジトリを加えることができます。

リポジトリはルートパッケージでのみ利用でき、依存関係で定義されたリポジトリは読み込まれません。なぜそうなっているかを知りたければ[FAQの項目](faqs/why-cant-composer-load-repositories-recursively.md)をお読みください。

依存関係解決をするとき、パッケージはリポジトリを上から下への順で見ていき、どこかでパッケージが見付かったらComposerは他のリポジトリを見るのを止めます。詳細は[リポジトリの優先度](articles/repository-priorities.md)の記事を読んでこの挙動を変える方法を見てください。

## 種別

### Composer

主なリポジトリの種別は`composer`リポジトリです。全てのパッケージメタデータを含む単一の`packages.json`ファイルを使っています。

またこれはpackagistが使っているリポジトリの種別です。`composer`リポジトリを参照するには、`packages.json`ファイルの前にパスを与えてください。packagistの場合、そのファイルは`/packages.json`に配置されるので、リポジトリのURLは`repo.packagist.org`となります。`example.org/packages.json`についてはリポジトリのURLは`example.org`になります。

```json
{
    "repositories": [
        {
            "type": "composer",
            "url": "https://example.org"
        }
    ]
}
```

#### packages

唯一必要なフィールドは`packages`です。JSONの構造は以下のようなものです。

```json
{
    "packages": {
        "vendor/package-name": {
            "dev-master": { @composer.json },
            "1.0.x-dev": { @composer.json },
            "0.0.1": { @composer.json },
            "1.0.0": { @composer.json }
        }
    }
}
```

`@composer.json`の印は最小のものとして含むパッケージのバージョンに由来する`composer.json`の内容になります。

* name
* version
* distまたはsource

以下は最小限のパッケージの定義です。

```json
{
    "name": "smarty/smarty",
    "version": "3.1.7",
    "dist": {
        "url": "https://www.smarty.net/files/Smarty-3.1.7.zip",
        "type": "zip"
    }
}
```

[スキーマ](04-schema.md)で指定される他のフィールドのいずれかを含むことができます。

#### notify-batch

`notify-batch`フィールドでは利用者がパッケージをインストールするときに毎回呼ばれるURLを指定できます。
URLは絶対パス（リポジトリと同じドメイン）ないし完全に修飾されたURLです。

値の一例：

```json
{
    "notify-batch": "/downloads/"
}
```

`monolog/monolog`パッケージを含む`example.org/packages.json`について、このようにすると以下のJSON要求本文とともに`example.org/downloads/`へPOST要求を送ります。

```json
{
    "downloads": [
        {"name": "monolog/monolog", "version": "1.2.1.0"}
    ]
}
```

バージョンフィールドはバージョン数の正規化された表現を含みます。

このフィールドは省略できます。

#### metadata-url、available-packages、available-package-patterns

`metadata-url`フィールドではリポジトリにある全てのパッケージを提供するURLテンプレートを与えます。空欄`%package%`を含まなければなりません。

このフィールドはComposer
v2で新しく登場したもので、`provider-includes`と`providers-url`が両方とも存在する場合、これらより優先されます。Composer
v1とComposer
v2両方の互換性のため、理想的には両方とも提供したいでしょう。しかし新しいリポジトリの実装はv2対応のみに対応しさえすればよいです。

一例：

```json
{
    "metadata-url": "/p2/%package%.json"
}
```

Composerがパッケージを探すときは毎回`%package%`をパッケージ名で置き換え、そのURLを取得します。開発安定性がそのパッケージについて許容される場合、`$packageName~dev`で再びURLを読み込むことができます（例：`/p2/foo/bar~dev.json`は`foo/bar`の開発版を探します）。

パッケージのバージョンを含む`foo/bar.json`と`foo/bar~dev.json`ファイルはfoo/barパッケージのバージョンのみを含まなければなりません。`{"packages":{"foo/bar":[……ここにバージョン……]}}`のような感じです。

キャッシュはIf-Modified-Sinceヘッダを使うことで行われます。ですから必ずLast-Modifiedヘッダを返して正確な内容であるようにしてください。

バージョンの配列は任意で[composer/metadata-minifier](https://packagist.org/packages/composer/metadata-minifier)の`Composer\MetadataMinifier\MetadataMinifier::minify()`を使って最小化できます。
もしそうした場合トップレベルに`"minified":
"composer/2.0"`キーを付け、Composerにバージョンのリストを展開して元のデータに戻さなければいけないことを示すべきです。
一例として https://repo.packagist.org/p2/monolog/monolog.json を参照してください。

存在しないパッケージを要求されたら404ステータスコードを返さなければなりません。このステータスコードによりComposerにこのパッケージがリポジトリに存在しないことが示されます。404応答は早く返してComposerがブロックされるのを回避するようにしてください。代替の404ページへのリダイレクトは避けてください。

リポジトリにごく少数のパッケージしかなく、404になる要求を避けたければ`packages.json`にリポジトリに含まれる全てのパッケージ名が配列になった`"available-packages"`キーを指定することもできます。代わりにパッケージ名のパターンの配列である`"available-package-patterns"`キーを指定することもできます（`*`だと任意の文字列に照合します。例：`vendor/*`ではComposerはこのリポジトリにある全ての照合したパッケージ名を探します）。

このフィールドは省略できます。

#### providers-api

`providers-api`フィールドでは与えられたパッケージ名を提供する全てのパッケージ、ただしその名前を持つパッケージ以外、を返すURLテンプレートを与えられます。空欄`%package%`を含まなければなりません。

例えば https://packagist.org/providers/monolog/monolog.json はmonolog/monologに
"provide" 規則を持つパッケージを一覧にしますが、monolog/monolog自体は一覧に挙がりません。

```json
{
    "providers-api": "https://packagist.org/providers/%package%.json",
}
```

このフィールドは省略できます。

#### list

`list`フィールドでは与えられたフィールド（もしくはフィルタが存在しなければ全ての名前）に照合するパッケージの名前を返すことができます。任意で`?filter=xx`クエリパラメータを受け付けるべきで、このクエリパラメータには任意の部分文字列に照合するワイルドカードとして`*`を含められます。

replace/provide規則はここでは考慮すべきではありません。

パッケージ名の配列を返さねばなりません。
```json
{
    "packageNames": [
        "a/b",
        "c/d"
    ]
}
```

例については<https://packagist.org/packages/list.json?filter=composer/*>を参照してください。

このフィールドは省略できます。

#### provider-includesとproviders-url

`provider-includes`フィールドではこのリポジトリから提供されるパッケージ名を一覧にするファイルの集まりを列挙できます。この場合ハッシュはファイルのsha256になります。

`providers-url`は提供するファイルをサーバーで見付ける方法を記述します。リポジトリのルートからの絶対パスです。`%package%`と`%hash%`の空欄を含まなければいけません。

これらのフィールドは、Composer v1かリポジトリが`metadata-url`フィールドを設定していない場合に使われます。

一例：

```json
{
    "provider-includes": {
        "providers-a.json": {
            "sha256": "f5b4bc0b354108ef08614e569c1ed01a2782e67641744864a74e788982886f4c"
        },
        "providers-b.json": {
            "sha256": "b38372163fac0573053536f5b8ef11b86f804ea8b016d239e706191203f6efac"
        }
    },
    "providers-url": "/p/%package%$%hash%.json"
}
```

これらのファイルにはファイルの完全性を検証するハッシュが含まれます。例えば次の通りです。

```json
{
    "providers": {
        "acme/foo": {
            "sha256": "38968de1305c2e17f4de33aea164515bc787c42c7e2d6e25948539a14268bb82"
        },
        "acme/bar": {
            "sha256": "4dd24c930bd6e1103251306d6336ac813b563a220d9ca14f4743c032fb047233"
        }
    }
}
```

上のファイルはこのリポジトリでacme/fooとacme/barが見付かることを宣言しています。`providers-url`で参照されたファイルを読み込み、ベンダーの名前空間が付いたパッケージ名で`%package%`で、`%hash%`をsha256フィールドで、それぞれ置き換えます。これらのファイル自体には[上](#packages)で前述したパッケージの定義が含まれます。

これらのフィールドは任意のものです。恐らく独自のリポジトリでは必要ないでしょう。

#### cURLとストリームオプション

リポジトリへはcURL（ext-curlが有効なComposer
2）またはPHPストリームのいずれかを使ってアクセスします。`options`パラメータを使って追加のオプションを設定できます。PHPストリームについては、任意の妥当はPHPストリームコンテキストオプションを設定できます。詳細は[コンテキストオプションとパラメータ](https://php.net/manual/en/context.php)を参照してください。cURLが使われているとき、ごく一部の`http`と`ssl`オプションしか設定することはできないように制限されます。

```json
{
    "repositories": [
        {
            "type": "composer",
            "url": "https://example.org",
            "options": {
                "http": {
                    "timeout": 60
                }
            }
        }
    ],
    "require": {
        "acme/package": "^1.0"
    }
}
```

### VCS

VCSはバージョンコントロールシステム (Version Control System)
から来ています。これにはgit、svn、fossil、hgのようなバージョニングシステムが含まれます。Composerにはこれらのシステムからパッケージをインストールするリポジトリ種別があります。

#### VCSリポジトリからパッケージを読み込む

これにはいくつかの使い途があります。
一番よくあるものとしては、サードパーティライブラリの独自のフォークを維持管理することです。
プロジェクトで或るライブラリを使用していて、ライブラリ内の何かを変更し、プロジェクトでパッチを適用したバージョンを使用しようと思ったとします。
ライブラリがGitHubにある場合（ほとんどのライブラリが当てはまります）、フォークして、変更をフォークにプッシュできます。
その後、プロジェクトの`composer.json`を更新します。
する必要があるのは、フォークをリポジトリとして追加し、バージョン制約を更新してカスタム ブランチを指すようにすることだけです。
`composer.json` でのみ、カスタムブランチ名の前に`"dev-"`を付けるべきです（実際のブランチ名の一部にしないでください）。
バージョン制約の命名規則については、[ライブラリ](02-libraries.md)を参照してください。

`bugfix`ブランチのバグを修正するためにmonologにパッチを当てたときの例は以下です。

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/igorw/monolog"
        }
    ],
    "require": {
        "monolog/monolog": "dev-bugfix"
    }
}
```

`php composer.phar
update`を実行すると、修正したバージョンの`monolog/monolog`が取得されます。packagistからのものではありません。

長期的にフォークするつもりがない限り、パッケージの名前を変更しないでください。
また、もし変更するならするで、元のパッケージから完全に離れたものにする必要があります。
独自リポジトリはpackagistよりも優先されるため、Composerは元のパッケージではなく自前のパッケージを正しく選択します。
パッケージを改名する場合、パッケージ名が既定のブランチから取得されるため、機能ブランチではなく、既定の（多くの場合マスター）ブランチで行う必要があります。

また、フォークされたリポジトリの`composer.json`ファイルの`name`プロパティを変更すると、上書きが機能しないことに注意してください。
上書きが機能するには元のものと合致する必要があるからです。

他の依存関係がフォークしたパッケージに依存している場合は、それをインラインエイリアスして、他の方法では一致しない制約に一致させることができます。
詳細については[エイリアスの記事を参照してください](articles/aliases.md)。

#### プライベートリポジトリを使う

GitHubとBitbucketのプライベートリポジトリを全く同じやり方で扱えます。

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url":  "git@bitbucket.org:vendor/my-private-repo.git"
        }
    ],
    "require": {
        "vendor/my-private-repo": "dev-master"
    }
}
```

唯一の要件は、gitクライアント用のSSHキーがインストールされていることです。

#### Gitの代替案

VCSリポジトリで対応しているバージョン管理システムはGitだけではありません。
以下に対応しています。

* **Git:** [git-scm.com](https://git-scm.com)
* **Subversion:** [subversion.apache.org](https://subversion.apache.org)
* **Mercurial:** [mercurial-scm.org](https://www.mercurial-scm.org)
* **Fossil**: [fossil-scm.org](https://www.fossil-scm.org/)

これらのシステムからパッケージを取得するにはそれぞれのクライアントがインストールされてる必要がありますが、これだと不便かもしれません。
このため、GitHubとBitbucketについては、これらのサイトが提供するAPIを使用してバージョン管理システムをインストールせずにパッケージを取得る特別な対応が入っています。
VCSリポジトリは、パッケージをzipとして取得する`dist`を提供します。

* **GitHub:** [github.com](https://github.com) (Git)
* **Bitbucket:** [bitbucket.org](https://bitbucket.org) (Git)

使用するVCSドライバーは、URLに基づいて自動的に検出されます。
ただし、何らかの理由で指定する必要がある場合は、`vcs`に代えて`bitbucket`、`github`、`gitlab`、`perforce`、`fossil`、`git`、`svn`、`hg`がリポジトリの種類として使えます。

githubリポジトリで`no-api`キーを`true`に設定すると、GitHub
APIは使用せず、他のgitリポジトリと同様にリポジトリがクローンされます。
ただし、`git`ドライバーを直接使用する場合とは異なり、Composerは依然としてgithubのzipファイルを使用しようとします。

以下の点に注意してください。

* **Composerに使用するドライバを選ばせるには**、リポジトリの種類は「vcs」として定義されている必要があります
* **既にプライベートリポジトリを使っている場合**、Composerはキャッシュへクローンすることになります。
 同じパッケージをドライバと一緒にインストールしたい場合、`composer clearcache`コマンドに続けて`composer
update`とすることでComposerのキャッシュを消去しdistからパッケージをインストールさせられることを覚えておきましょう
* VCSドライバ`git-bitbucket`は`bitbucket`に取って代わられたため時代遅れです

#### Bitbucketドライバ設定

> **Bitbucketのリポジトリのエンドポイントはgitではなくhttpsになっている必要がある点に注意してください。**

bitbucketリポジトリが準備できたら[認証の準備](articles/authentication-for-private-packages.md#bitbucket-oauth)もする必要があるでしょう。

#### Subversionのオプション

Subversion自体にはブランチとタグの概念がないため、Composerは既定でコードが`$url/trunk`、`$url/branches`、`$url/tags`にあるという前提を置きます。
リポジトリの配置が異なる場合は、それらの値を変更できます。
たとえば、大文字の名前を使用した場合、次のようにリポジトリを構成できます。

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "http://svn.example.org/projectA/",
            "trunk-path": "Trunk",
            "branches-path": "Branches",
            "tags-path": "Tags"
        }
    ]
}
```

ブランチのディレクトリもタグのディレクトリもなければ`branches-path`ないし`tags-path`を`false`に設定することで完全に無効にできます。

パッケージが副ディレクトリにある、例えば`/trunk/foo/bar/composer.json`と`/tags/1.0/foo/bar/composer.json`にあるなら、`"package-path"`オプションを副ディレクトリに設定することでComposerがアクセスできるようにさせられます。
この例では`"package-path": "foo/bar/"`となるでしょう。

プライベートなSubversionリポジトリがあるなら設定のhttp-basic節に資格情報を保存しておけます（[スキーマ](04-schema.md)を参照）。

```json
{
    "http-basic": {
        "svn.example.org": {
            "username": "username",
            "password": "password"
        }
    }
}
```

Subversionクライアントが既定で資格情報を保存するように構成されている場合、これらの資格情報は現在の利用者用に保存され、このサーバー用に保存されている既存の資格情報は上書きされます。
この挙動を変更するには、次のようにリポジトリ構成で`"svn-cache-credentials"`オプションを設定します。

```json
{
    "repositories": [
        {
            "type": "vcs",
            "url": "http://svn.example.org/projectA/",
            "svn-cache-credentials": false
        }
    ]
}
```

### パッケージ

上記のどの方法でもComposerに対応していないプロジェクトを使いたい場合でも、`package`リポジトリを使って自分でパッケージを定義できます。

基本的に`composer`リポジトリの`package.json`に含まれるのと同じ情報を定義しますが、単一のパッケージ用限定です。繰り返しますが、最小限必要なフィールドは`name`、`version`、そして`dist`または`source`のいずれかです。

以下はsmartyテンプレートエンジンの例です。

```json
{
    "repositories": [
        {
            "type": "package",
            "package": {
                "name": "smarty/smarty",
                "version": "3.1.7",
                "dist": {
                    "url": "https://www.smarty.net/files/Smarty-3.1.7.zip",
                    "type": "zip"
                },
                "source": {
                    "url": "http://smarty-php.googlecode.com/svn/",
                    "type": "svn",
                    "reference": "tags/Smarty_3_1_7/distribution/"
                },
                "autoload": {
                    "classmap": ["libs/"]
                }
            }
        }
    ],
    "require": {
        "smarty/smarty": "3.1.*"
    }
}
```

source部分は放置しておくのが普通です。本当に必要なことはまずないからです。

> **補足**：このリポジトリ種別には2、3の制約がありできる限り避けるべきです。
>
> - Composerは`version`フィールドを変えない限りパッケージを更新しません。
> - Composerはコミット参照を更新しないので、参照として`master`を使う場合、強制的に更新するためにパッケージを削除し、不安定なロックファイルに対処しなければならなくなるでしょう。

`package`リポジトリ中の`"package"`キーには複数バージョンのパッケージを定義する配列を設定できます。

```json
{
    "repositories": [
        {
            "type": "package",
            "package": [
                {
                    "name": "foo/bar",
                    "version": "1.0.0",
                    ...
                },
                {
                    "name": "foo/bar",
                    "version": "2.0.0",
                    ...
                }
            ]
        }
    ]
}
```

## 自分でホスティングする

多分ほとんどの場合でパッケージをpackagistに置きたいものと思われますが、自分のリポジトリをホスティングすることによる用途もあります。

* **プライベートな企業のパッケージ：**内部的なパッケージ用にComposerを使っている企業に所属しているなら、それらのパッケージをプライベートにしておきたいかもしれません。

* **別のエコシステム:**
  独自のエコシステムを持つプロジェクトがあり、より大きなPHPコミュニティからそのパッケージを実際に再利用できない場合は、packagistから分離させておきたいかもしれません。
  一例はWordPressプラグインです。

自分のパッケージをホスティングするには、ネイティブな`composer`の種類のリポジトリが推奨されます。
一番の効率性がもたらされるからです。

`composer`リポジトリを作る上での手助けになるツールはいくつかあります。

### プライベートPackagist

[プライベートPackagist](https://packagist.com/)ではGitHub、Packagist.org、その他のパッケージリポジトリのミラーリングと共にプライベートパッケージのホスティングを提供するアプリケーションです。
Packagistでも立てられていますが、自分で立てることもできます。

詳細は[Packagist.com](https://packagist.com/)をご確認ください。

### Satis

Satisは静的な`composer`リポジトリ生成器です。
これはpackagistを超軽量にして、静的なファイルを基盤にしたバージョンのようなものです。

Satisにはリポジトリを含む`composer.json`を与えます。
リポジトリとしてよくあるのはVCSやパッケージレポジトリの定義です。
`require`されるパッケージを全て取得し、`packages.json`を吐き出しますが、これが`composer`リポジトリになります。

詳細は[satisのGitHubリポジトリ](https://github.com/composer/satis)と[プライベートパッケージを扱うことについての記事](articles/handling-private-packages.md)をご確認ください。

### アーティファクト

前述のどのリポジトリの種類もオンラインにできない場合があります。
VCSが使われていたとしても例外ではありません。
典型的な例は、ビルドアーティファクトによる組織間のライブラリ交換です。
もちろん、ほとんどの場合、これらはプライベートです。
これらのアーカイブをそのまま使用するには、これらのプライベートパッケージのZIPまたはTARアーカイブを含むフォルダーに対して、種別`artifact`のリポジトリを使用できます。

```json
{
    "repositories": [
        {
            "type": "artifact",
            "url": "path/to/directory/with/zips/"
        }
    ],
    "require": {
        "private-vendor-one/core": "15.6.2",
        "private-vendor-two/connectivity": "*",
        "acme-corp/parser": "10.3.5"
    }
}
```

それぞれのzipアーティファクトとは、ルートフォルダにある`composer.json`があるZIPアーカイブです。

```shell
unzip -l acme-corp-parser-10.3.5.zip
```
```text
composer.json
...
```

パッケージのバージョンが異なる2つのアーカイブがある場合、両方ともインポートされます。
新しいバージョンのアーカイブがアーティファクトフォルダーに追加された状態で`update`を実行すると、そのバージョンもインポートされ、Composerは最新版に更新されます。

### パス

アーティファクトリポジトリに加えて、絶対パスまたは相対パスのローカルディレクトリに依存するパスを使用できます。
これはモノリシックリポジトリを扱う場合に特に役立ちます。

例えばリポジトリが以下のディレクトリ構造になっているとします。
```text
...
├── apps
│   └── my-app
│       └── composer.json
├── packages
│   └── my-package
│       └── composer.json
...
```

そうして依存関係として`apps/my-app/composer.json`ファイルにパッケージ`my/package`を加えるには、以下の構成が使えます。

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../packages/my-package"
        }
    ],
    "require": {
        "my/package": "*"
    }
}
```

パッケージがローカルのVCSリポジトリである場合、バージョンは現在チェックアウトされているブランチまたはタグによって推測されます。
それ以外の場合は、パッケージの`composer.json`ファイルでバージョンを明示的に定義すべきです。
これらの方法でバージョンが解決できない場合は、`dev-master`と見なされます。

バージョンがローカルのVCSリポジトリから推測できない場合、もしくはそのバージョンを上書きしたい場合は、リポジトリの宣言時に`versions`オプションが使えます。

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../packages/my-package",
            "options": {
                "versions": {
                    "my/package": "4.2-dev"
                }
            }
        }
    ]
}
```

可能なときはローカルパッケージがシンボリックリンクされます。
この場合端末の出力は`Symlinking from ../../packages/my-package`となります。
シンボリックリンクでき*ない*場合はパッケージが複製されます。
その場合端末の出力は`Mirrored from ../../packages/my-package`となります。

既定のフォールバック戦略に代えて、`"symlink": true`としてシンボリックリンクにしたり、`"symlink":
false`オプションでミラーリングしたりすることを強制できます。
ミラーリングを強制するとモノリシックレポジトリからパッケージをデプロイしたり生成したりする際に便利なことがあります。

> **補足：** Windowsでは管理者でない利用者によって作成される可能性があるため、NTFSジャンクションを使ってディレクトリのシンボリックリンクが実装されています。
> Windows 7より前のバージョンまたは`proc_open`が無効にされている場合は常にミラーリングが使用されます。

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../packages/my-package",
            "options": {
                "symlink": false
            }
        }
    ]
}
```

チルダを先頭に付けると現在の利用者のホームフォルダに展開され、環境変数はWIndowsとLinux/Macの両方の記法で解析されます。
例えば`~/git/mypackage`は自動的に`/home/<利用者名>/git/mypackage`からクローンしたmypackageを読み込みます。
`$HOME/git/mypackage`としたり`%USERPROFILE%/git/mypackage`としても同じことです。

> **補足：** リポジトリのパスは`*`や`?`のようなワイルドカードも含められます。
> 詳細については[PHPのglob関数](https://php.net/glob)を参照してください。

（composer.lockファイルに現れる）パッケージのdistへの参照が構築される方法を構成できます。

以下のモードが存在します。
- `none`：参照は常に空です。
  これによりロックファイル中のロックファイル競合を低減する助けになる可能性がありますが、直近に更新があるとパッケージが最新の状態になっているかが比較的不明瞭になります。
- `config`：参照はパッケージのcomposer.jsonとリポジトリの設定のハッシュに基づいて構築されます
- `auto`（既定で使用されます）：参照は`comfig`のようなハッシュに基づいて構築されます。
  ただしパッケージフォルダがgitリポジトリを含んでいる場合、代わりにHEADコミットのハッシュが参照として使われます。

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../packages/my-package",
            "options": {
                "reference": "config"
            }
        }
    ]
}
```

## Packagist.orgを無効にする

以下を`composer.json`に加えると既定のPackagist.orgリポジトリを無効にできます。

```json
{
    "repositories": [
        {
            "packagist.org": false
        }
    ]
}
```

大域的な構成フラグを使うことで、大域的にPackagist.orgを無効にできます。

```shell
php composer.phar config -g repo.packagist false
```

&larr; [スキーマ](04-schema.md)  | [設定](06-config.md) &rarr;
