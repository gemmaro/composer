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

[Packagist.org](https://packagist.org)で公開されたパッケージを見付けてください。

プライベートなパッケージのホスティングについては[プライベートPackagist](https://packagist.com)をご確認ください。

コミュニティ
------------------

告知についてはTwitterで[@packagist](https://twitter.com/packagist)または[@seldaek](https://twitter.com/seldaek)をフォロー、または[#composerphp](https://twitter.com/search?q=%23composerphp&src=typed_query&f=live)ハッシュタグをご確認ください。

サポートについては、Stack
Overflowで[Composerに関係する質問](https://stackoverflow.com/questions/tagged/composer-php)の良い集積がありますし、[GitHubディスカッション](https://github.com/composer/composer/discussions)も使えます。

本プロジェクトは[貢献者の行動規範](https://www.contributor-covenant.org/version/1/4/code-of-conduct/)の元でリリースされている点にご留意ください。
本プロジェクトとコミュニティに参加することにより、これらの条項を遵守することに同意したことになります。

要件
------

#### 最新のComposer

最新版にはPHP 7.2.5以上が必要です。

#### Composer 2.2 LTS（長期期間対応）

PHPのバージョン5.3.2から8.1まではComposer (2.2.x)のLTS対応でまだ対応されています。
インストーラ`self-update`コマンドを走らせると手元のPHPに見合う適切なComposerのバージョンが自動的に選択されるでしょう。

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

特筆すべきこととして、これらのバイナリの依存関係の必要性は個々の用途によって様々です。
しかしほとんどの利用者にとっては、Composerに必須な依存関係はたった2つです。
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
