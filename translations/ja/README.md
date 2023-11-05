<p align="center">
    <a href="https://getcomposer.org">
        <img src="https://getcomposer.org/img/logo-composer-transparent.png" alt="Composer">
    </a>
</p>
<h1 align="center">PHPのための依存関係管理</h1>

ComposerはPHPのプロジェクトの依存関係を宣言し、管理し、インストールする助けになります。

詳細情報とドキュメントについては[https://getcomposer.org/](https://getcomposer.org/)を参照してください。

[![Continuous
Integration](https://github.com/composer/composer/workflows/Continuous%20Integration/badge.svg?branch=main)](https://github.com/composer/composer/actions)

インストールと使い方
------------------------------

[公式の解説](https://getcomposer.org/download/)に従い、ダウンロード、インストールしてください。

使用方法については[ドキュメント](https://getcomposer.org/doc/)を参照してください。

パッケージ
---------------

[Packagist.org](https://packagist.org)に公開されているパッケージがあります。

私有パッケージのホスティングについては[私有Packagist](https://packagist.com)をご確認ください。

コミュニティ
------------------

告知についてはTwitterで[@packagist](https://twitter.com/packagist)または[@seldaek](https://twitter.com/seldaek)をフォローしたり、[#composerphp](https://twitter.com/search?q=%23composerphp&src=typed_query&f=live)ハッシュタグを確認したりしてください。

サポートについては、Stack
Overflowで[Composerに関係する良い質問](https://stackoverflow.com/questions/tagged/composer-php)がされてきました。
また、[GitHubディスカッション](https://github.com/composer/composer/discussions)も使えます。

本プロジェクトは[貢献者の行動規範](https://www.contributor-covenant.org/version/1/4/code-of-conduct/)の元でリリースされている点にご留意ください。
本プロジェクトとコミュニティへ参加すると、これらの条項を遵守することに同意したこととなります。

要件
------

#### 最新のComposer

最新版にはPHP 7.2.5以上が必要です。

#### Composer 2.2 LTS（長期期間対応）

PHPのバージョン5.3.2から8.1まではComposer (2.2.x)のLTS対応でまだ対応されています。
インストーラの`self-update`コマンドを走らせると、手元のPHPに見合う適切なComposerのバージョンが自動的に選択されるでしょう。

#### バイナリの依存関係

- `7z`（ないし`7zz`）
- `unzip`（`7z`が無い場合）
- `gzip`
- `tar`
- `unrar`
- `xz`
- Git (`git`)
- Mercurial (`hg`)
- Fossil (`fossil`)
- Perforce (`p4`)
- Subversion (`svn`)

大事なことですが、これらのバイナリの依存関係の必要性は個々の用途によって様々です。
しかし殆どの利用者にとっては、Composerに必須な依存関係はたった2つです。
`7z`（または`7zz`や`unzip`）と`git`です。

作者
------

- Nils Adermann | [GitHub](https://github.com/naderman)  |
  [Twitter](https://twitter.com/naderman) | <naderman@naderman.de> |
  [naderman.de](https://naderman.de)
- Jordi Boggiano | [GitHub](https://github.com/Seldaek) |
  [Twitter](https://twitter.com/seldaek) | <j.boggiano@seld.be> |
  [seld.be](https://seld.be)

本プロジェクトに参加している[貢献者](https://github.com/composer/composer/contributors)の一覧もご参照ください。

セキュリティ報告書
---------------------------

慎重を要する問題については全て[security@packagist.org](mailto:security@packagist.org)にお送りください。
ありがとうございます。

利用許諾
------------

ComposerはMITライセンスの下で利用が許諾されます。
詳細は[LICENSE](LICENSE)をご参照ください。

謝辞
------

- 本プロジェクトのSolverについて、openSUSEの[Libzypp
  satsolver](https://en.opensuse.org/openSUSE:Libzypp_satsolver)のPHP移植を開始しました。

- - -

本和訳にあたっての著作権表示を以下に示します。

Copyright (C) 2013--2015 kohkimakimoto.<br>
Copyright (C) 2022, 2023 gemmaro.

この翻訳は[kohkimakimoto][]氏による翻訳を元に改変を加えています。
同氏の翻訳リポジトリは[`kohkimakimoto/getcomposer.org_doc_jp`][repo]に、Webサイトは[『Composer ドキュメント日本語訳』の「はじめに」][site]にあります。
コミット[`9b7073bf08140994039b4c008650a0ce1e3173fb`][commit]時点で翻訳されていた範囲は以下の通りです。

| 章名                                  | ファイル                | 備考                                  |
|---------------------------------------|-------------------------|---------------------------------------|
| [イントロダクション][intro]           | `doc/00-intro.md`       |                                       |
| [基本的な使い方][basic]               | `doc/01-basic-usage.md` |                                       |
| [ライブラリ][lib]                     | `doc/02-libraries.md`   |                                       |
| [コマンドラインインターフェース][cli] | `doc/03-cli.md`         | 「install」節の「オプション」小節まで |
| [composer.json][schema]               | `doc/04-schema.md`      | 冒頭部分                              |
| [コミュニティ][community]             | `doc/06-community.md`   |                                       |

また、対応するComposer本体のコミットは[`a1e4ca4f9bacfd3dc08e0546bff2d30cb006ea27`][original-commit]としました。

本翻訳は上記既訳を最新版に追従することを目的としています。
そのため既訳の修正に加えて新規に追加された原文への訳が含まれます。
本翻訳も原文にしたがい、[MITライセンス][license]の下に使用が許諾されます。

[basic]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/01-basic-usage.html
[cli]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/03-cli.html
[commit]: https://github.com/kohkimakimoto/getcomposer.org_doc_jp/commit/9b7073bf08140994039b4c008650a0ce1e3173fb
[community]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/06-community.html
[intro]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/00-intro.html
[kohkimakimoto]: https://github.com/kohkimakimoto
[lib]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/02-libraries.html
[license]: https://github.com/composer/composer/blob/main/LICENSE
[original-commit]: https://github.com/composer/composer/commit/a1e4ca4f9bacfd3dc08e0546bff2d30cb006ea27
[repo]: https://github.com/kohkimakimoto/getcomposer.org_doc_jp
[schema]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/04-schema.html
[site]: https://kohkimakimoto.github.io/getcomposer.org_doc_jp/doc/00-intro.html
