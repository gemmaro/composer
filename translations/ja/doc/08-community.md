# コミュニティ

既に多くの人々がcomposerを使い、少なくない方々が貢献しています。

## 貢献

Composerに貢献したいときは、[README](https://github.com/composer/composer)と[CONTRIBUTING](https://github.com/composer/composer/blob/main/.github/CONTRIBUTING.md)のドキュメントを読んでください。

最重要の指針は以下に記述されます。

> 全てのコードの貢献は、コミット権限をもつ人を含めて、プルリクエストを通じて行われます。
> マージ前に中核開発者による承認がなされなければなりません。
> これは全てのコードに適切なレビューを確実に行うためです。
>
> プロジェクトをフォークし、機能ブランチを作成し、そしてプルリクエストを送ってください。
>
> 一貫性のあるコードベースにするためにコードが[PSR-12コーディング規約](https://www.php-fig.org/psr/psr-12/)に従っていることを確認すべきです。


### 翻訳

日本語訳の改善を歓迎します。
`translations/po/ja.po`に原文と翻訳の対応があり、このファイルから日本語用のMarkdownファイル`translations/ja/**/*.md`が生成されます。
したがって後者のMarkdownファイルではなく、前者のGettext POファイルを編集してください。

翻訳は[po4a][]で管理されています。
`npm run translate`とするとPOファイルの更新とMarkdownファイルの生成が行われます。
また、`package.json`には`test:ja`と`test:md`のnpm scriptsが定義されています。
`test:ja`は[Textlint][]により日本語を検査し、`test:md`は[markdownlint][]によりMarkdownの構文を検査します。

[Textlint]: https://textlint.github.io/
[markdownlint]: https://github.com/igorshubovych/markdownlint-cli/
[po4a]: https://po4a.org/
## サポート

IRCチャンネルは<irc.libera.chat>の
[#composer](ircs://irc.libera.chat:6697/composer) にあります。

[Stack Overflow](https://stackoverflow.com/questions/tagged/composer-php) と
[GitHub Discussions](https://github.com/composer/composer/discussions)
には両方ともComposerに関係する質問が寄せられています。

有料のサポートについては、Composerに関係するサポートを[Private
Packagist](https://packagist.com)の顧客にチャットとEメールを介して提供しています。


&larr; [ランタイム](07-runtime.md)
