### [2.7.3] 2024-04-19

  * 後方互換性についての警告：`https_proxy`環境変数が`http_proxy`の値にフォールバックする点を修正しました。
    まだそのままになっていますが、警告を伴うようになりました。
    https_proxyを空に設定してフォールバックを除くことができるようになりました。
    Composer 2.8.0ではフォールバックを削除するため、本警告にご注意ください (#11915)。
  * `show`コマンドと`outdated`コマンドを修正し、パッケージの一覧を表示するときの先頭の`v`を除きました。
    例えば`v1.2.3`のような見た目をしていました (#11925)。
  * `audit`コマンドを修正し、CVEが存在しないときに識別番号を表示しないようにしました。
    勧告識別番号が表示されるようになりました (#11892)。
  * `project`種別を持つパッケージで表示される既定のバージョンが欠けていることについての警告を修正しました。
    これらのパッケージは大抵バージョン管理されておらず、循環参照がないためです (#11885)。
  * PHP 8.4の非推奨の警告を修正しました。
  * `clear-cache`コマンドを修正し、ローカルのcomposer.jsonのconfig.cache-dir設定を考慮するようにしました
    (#11921)。
  * `status`コマンドが失敗したダウンロードとインストールのプロミスを正しく扱っていなかった点を修正しました (#11889)。
  * GitHubの寄付ファイルの`buy_me_a_coffee`への対応を追加しました (#11902)。
  * SSHのURLに`hg`の対応を追加しました (#11878)。
  * 幾つかの環境変数を修正し、整数値がクラッシュを起こさないようにしました (#11908)。
  * IOInterfaceをPSR-3ロガーとして使う際に文脈データが出力されないように修正しました (#11882)。

### [2.7.2] 2024-03-11

  * `composer --version`を走らせる際に、PHPのバージョンについての情報を追加しました (#11866)。
  * 根幹のバージョンが見合たらなかったときの警告を追加しました (#11858)。
  * ルート権限で走らせる際に、幾つかの状況下では依然としてプラグインが有効だった問題を修正しました (c3efff91f)。
  * `outdated --ignore ...`が依然として無視されたパッケージの最新版を読み込もうとしていた問題を修正しました
    (#11863)。
  * インストールパスの途中でシンボリックリンクが壊れたときの対処について修正しました (#11864)。
  * `update --lock`が依然として幾つかのメタ情報を間違った内容で更新していた問題を修正しました (#11850, #11787)。

### [2.7.1] 2024-02-09

  * 2.7.0で利用者が出喰わすよくある問題に対して補足を入れるために、プラグインが無効化されたときの警告を幾つか追加しました (#11842)。
  * pharから走らせたときに`diagnose`でのComposerの依存関係の監査が失敗する問題を修正しました。

### [2.7.0] 2024-02-08

  * セキュリティ：危殆化したベンダーディレクトリの内容を介したコードの実行と権限昇格の可能性を修正しました (GHSA-7c6p-848j-wh5h
    / CVE-2024-24821)。
  * `audit.abandoned`構成設定の期待値を`fail`に変更しました。
    望ましくなければ`report`や`ignore`に設定してください。
    または`COMPOSER_AUDIT_ABANDONED`環境変数も使えます (#11643)。
  * `update`/`require`/`remove`コマンドに--minimal-changes (-m)
    フラグを追加し、--with-dependenciesで部分的な更新を掛けつつ、推移的な依存関係で絶対に必要なものだけを変更できるようにしました
    (#11665)。
  * `outdated`/`show`コマンドに--sort-by-age (-A)
    フラグを追加し、それぞれリリース日による整列（古いものが最初に来ます）とリリース日の表示ができるようにしました (#11762)。
  * `show`コマンドで`--self`を`--installed`や`--locked`と組み合わせる対応を追加しました。
    根幹パッケージを出力されるパッケージの一覧に追加できるようにするための変更です (#11785)。
  * 深刻度の情報を`audit`コマンドの出力に追加しました (#11702)。
  * composer.jsonに`scripts-aliases`最上位キーを追加しました。
    定義した自前のスクリプトに別称を定義できます (#11666)。
  * 接続が時間切れになったときにIPv4にフォールバックする対応を加えました。
    また、IPv4やIPv6に強制するための環境変数`COMPOSER_IPRESOLVE`も追加しました。
    それぞれ`4`および`6`に設定できます (#11791)。
  * `outdated`の--ignore引数にワイルドカードの対応を追加しました (#11831)。
  * `bump`コマンドに、`*`を`>=現在のバージョン`に上げる対応を追加しました (#11694)。
  * `validate`コマンドに、どうあっても照合する可能性のない制約の検出を追加しました (#11829)。
  * とても冗長なモード (-vv) で走らせているときに、パッケージのソース情報を`install`の出力に追加するようにしました。
  * `diagnose`コマンドでComposer自体に含まれる依存関係の監査を追加しました (#11761)。
  * `diagnose`コマンドの出力にGitHubトークンの失効日を追加しました (#11688)。
  * why/why-notコマンドに非ゼロの状態コードを追加しました (#11796)。
  * `show --direct <package>`を間接ないし推移的な依存関係で呼び出したときのエラーを追加しました (#11728)。
  * `COMPOSER_FUND=0`環境変数を追加し、募金の呼び掛けを隠せるようにしました (#11779)。
  * `bump`コマンドを修正し、`v`前置詞が必要なパッケージのバージョンを上げないようにしました (#11764)。
  * ルートユーザーとして非対話的に走らせているときに、プラグインが自動的に無効になる事象を修正しました。
  * `update
    --lock`を修正し、distのreference/url/checksumがピン留めされたままになっていなかった点を修正しました
    (#11787)。
  * ロックファイルが存在していない場合に`require`コマンドが最後にクラッシュする問題を修正しました (#11814)。
  * 固定された依存関係を監査するときにルートの別称が問題を起こす点を修正しました (#11771)。
  * `require`コマンドで4つのコンポーネントでバージョンを扱うときの問題を修正しました (#11716)。
  * Symfony 7の互換性の問題を修正しました。
  * `require`コマンドの--dry-runの後、composer.jsonが最新の状態に追従できない問題を修正しました (#11747)。
  * 特定の状況下で警告が間違って表示されていた点を修正しました (#11786, #11760, #11803)。

### [2.6.6] 2023-12-08

  * 要件symfony/consoleから7.xを除外するように修正しました。
    Composer 2.6とは互換性が無いからです。
    2.7では互換性があるでしょう (#11741)
  * libpqの解析を修正し、可能であれば大域定数を使うようにしました (#11684)
  * 一時制約の失敗があった更新でのエラー出力を修正しました (#11692)

### [2.6.5] 2023-10-06

  * vendorディレクトリに壊れたシンボリックリンクが含まれる場合の失敗を修正しました (#11670)。
  * Composerのzipアーカイブから欠けていたcomposer.lockを修正しました (#11674)。
  * 2.6.4で変わったAutoloadGenerator::dump()の非BCシグネチャを修正しました (cb363b0e8)。

[2.7.3]: https://github.com/composer/composer/compare/2.7.2...2.7.3
[2.7.2]: https://github.com/composer/composer/compare/2.7.1...2.7.2
[2.7.1]: https://github.com/composer/composer/compare/2.7.0...2.7.1
[2.7.0]: https://github.com/composer/composer/compare/2.6.6...2.7.0
[2.6.6]: https://github.com/composer/composer/compare/2.6.5...2.6.6
[2.6.5]: https://github.com/composer/composer/compare/2.6.4...2.6.5
[2.6.4]: https://github.com/composer/composer/compare/2.6.3...2.6.4
[2.6.3]: https://github.com/composer/composer/compare/2.6.2...2.6.3
[2.6.2]: https://github.com/composer/composer/compare/2.6.1...2.6.2
[2.6.1]: https://github.com/composer/composer/compare/2.6.0...2.6.1
[2.6.0]: https://github.com/composer/composer/compare/2.5.8...2.6.0
[2.5.8]: https://github.com/composer/composer/compare/2.5.7...2.5.8
[2.5.7]: https://github.com/composer/composer/compare/2.5.6...2.5.7
[2.5.6]: https://github.com/composer/composer/compare/2.5.5...2.5.6
[2.5.5]: https://github.com/composer/composer/compare/2.5.4...2.5.5
[2.5.4]: https://github.com/composer/composer/compare/2.5.3...2.5.4
[2.5.3]: https://github.com/composer/composer/compare/2.5.2...2.5.3
[2.5.2]: https://github.com/composer/composer/compare/2.5.1...2.5.2
[2.5.1]: https://github.com/composer/composer/compare/2.5.0...2.5.1
[2.5.0]: https://github.com/composer/composer/compare/2.4.4...2.5.0
[2.4.4]: https://github.com/composer/composer/compare/2.4.3...2.4.4
[2.4.3]: https://github.com/composer/composer/compare/2.4.2...2.4.3
[2.4.2]: https://github.com/composer/composer/compare/2.4.1...2.4.2
[2.4.1]: https://github.com/composer/composer/compare/2.4.0...2.4.1
[2.4.0]: https://github.com/composer/composer/compare/2.4.0-RC1...2.4.0
[2.4.0-RC1]: https://github.com/composer/composer/compare/2.3.10...2.4.0-RC1
[2.3.10]: https://github.com/composer/composer/compare/2.3.9...2.3.10
[2.3.9]: https://github.com/composer/composer/compare/2.3.8...2.3.9
[2.3.8]: https://github.com/composer/composer/compare/2.3.7...2.3.8
[2.3.7]: https://github.com/composer/composer/compare/2.3.6...2.3.7
[2.3.6]: https://github.com/composer/composer/compare/2.3.5...2.3.6
[2.3.5]: https://github.com/composer/composer/compare/2.3.4...2.3.5
[2.3.4]: https://github.com/composer/composer/compare/2.3.3...2.3.4
[2.3.3]: https://github.com/composer/composer/compare/2.3.2...2.3.3
[2.3.2]: https://github.com/composer/composer/compare/2.3.1...2.3.2
[2.3.1]: https://github.com/composer/composer/compare/2.3.0...2.3.1
[2.3.0]: https://github.com/composer/composer/compare/2.3.0-RC2...2.3.0
[2.3.0-RC2]: https://github.com/composer/composer/compare/2.3.0-RC1...2.3.0-RC2
[2.3.0-RC1]: https://github.com/composer/composer/compare/2.2.9...2.3.0-RC1
[2.2.17]: https://github.com/composer/composer/compare/2.2.16...2.2.17
[2.2.16]: https://github.com/composer/composer/compare/2.2.15...2.2.16
[2.2.15]: https://github.com/composer/composer/compare/2.2.14...2.2.15
[2.2.14]: https://github.com/composer/composer/compare/2.2.13...2.2.14
[2.2.13]: https://github.com/composer/composer/compare/2.2.12...2.2.13
[2.2.12]: https://github.com/composer/composer/compare/2.2.11...2.2.12
[2.2.11]: https://github.com/composer/composer/compare/2.2.10...2.2.11
[2.2.10]: https://github.com/composer/composer/compare/2.2.9...2.2.10
[2.2.9]: https://github.com/composer/composer/compare/2.2.8...2.2.9
[2.2.8]: https://github.com/composer/composer/compare/2.2.7...2.2.8
[2.2.7]: https://github.com/composer/composer/compare/2.2.6...2.2.7
[2.2.6]: https://github.com/composer/composer/compare/2.2.5...2.2.6
[2.2.5]: https://github.com/composer/composer/compare/2.2.4...2.2.5
[2.2.4]: https://github.com/composer/composer/compare/2.2.3...2.2.4
[2.2.3]: https://github.com/composer/composer/compare/2.2.2...2.2.3
[2.2.2]: https://github.com/composer/composer/compare/2.2.1...2.2.2
[2.2.1]: https://github.com/composer/composer/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/composer/composer/compare/2.2.0-RC1...2.2.0
[2.2.0-RC1]: https://github.com/composer/composer/compare/2.1.14...2.2.0-RC1
[2.1.14]: https://github.com/composer/composer/compare/2.1.13...2.1.14
[2.1.13]: https://github.com/composer/composer/compare/2.1.12...2.1.13
[2.1.12]: https://github.com/composer/composer/compare/2.1.11...2.1.12
[2.1.11]: https://github.com/composer/composer/compare/2.1.10...2.1.11
[2.1.10]: https://github.com/composer/composer/compare/2.1.9...2.1.10
[2.1.9]: https://github.com/composer/composer/compare/2.1.8...2.1.9
[2.1.8]: https://github.com/composer/composer/compare/2.1.7...2.1.8
[2.1.7]: https://github.com/composer/composer/compare/2.1.6...2.1.7
[2.1.6]: https://github.com/composer/composer/compare/2.1.5...2.1.6
[2.1.5]: https://github.com/composer/composer/compare/2.1.4...2.1.5
[2.1.4]: https://github.com/composer/composer/compare/2.1.3...2.1.4
[2.1.3]: https://github.com/composer/composer/compare/2.1.2...2.1.3
[2.1.2]: https://github.com/composer/composer/compare/2.1.1...2.1.2
[2.1.1]: https://github.com/composer/composer/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/composer/composer/compare/2.1.0-RC1...2.1.0
[2.1.0-RC1]: https://github.com/composer/composer/compare/2.0.14...2.1.0-RC1
[2.0.14]: https://github.com/composer/composer/compare/2.0.13...2.0.14
[2.0.13]: https://github.com/composer/composer/compare/2.0.12...2.0.13
[2.0.12]: https://github.com/composer/composer/compare/2.0.11...2.0.12
[2.0.11]: https://github.com/composer/composer/compare/2.0.10...2.0.11
[2.0.10]: https://github.com/composer/composer/compare/2.0.9...2.0.10
[2.0.9]: https://github.com/composer/composer/compare/2.0.8...2.0.9
[2.0.8]: https://github.com/composer/composer/compare/2.0.7...2.0.8
[2.0.7]: https://github.com/composer/composer/compare/2.0.6...2.0.7
[2.0.6]: https://github.com/composer/composer/compare/2.0.5...2.0.6
[2.0.5]: https://github.com/composer/composer/compare/2.0.4...2.0.5
[2.0.4]: https://github.com/composer/composer/compare/2.0.3...2.0.4
[2.0.3]: https://github.com/composer/composer/compare/2.0.2...2.0.3
[2.0.2]: https://github.com/composer/composer/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/composer/composer/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/composer/composer/compare/2.0.0-RC2...2.0.0
[2.0.0-RC2]: https://github.com/composer/composer/compare/2.0.0-RC1...2.0.0-RC2
[2.0.0-RC1]: https://github.com/composer/composer/compare/2.0.0-alpha3...2.0.0-RC1
[2.0.0-alpha3]: https://github.com/composer/composer/compare/2.0.0-alpha2...2.0.0-alpha3
[2.0.0-alpha2]: https://github.com/composer/composer/compare/2.0.0-alpha1...2.0.0-alpha2
[2.0.0-alpha1]: https://github.com/composer/composer/compare/1.10.7...2.0.0-alpha1
[1.10.23]: https://github.com/composer/composer/compare/1.10.22...1.10.23
[1.10.22]: https://github.com/composer/composer/compare/1.10.21...1.10.22
[1.10.21]: https://github.com/composer/composer/compare/1.10.20...1.10.21
[1.10.20]: https://github.com/composer/composer/compare/1.10.19...1.10.20
[1.10.19]: https://github.com/composer/composer/compare/1.10.18...1.10.19
[1.10.18]: https://github.com/composer/composer/compare/1.10.17...1.10.18
[1.10.17]: https://github.com/composer/composer/compare/1.10.16...1.10.17
[1.10.16]: https://github.com/composer/composer/compare/1.10.15...1.10.16
[1.10.15]: https://github.com/composer/composer/compare/1.10.14...1.10.15
[1.10.14]: https://github.com/composer/composer/compare/1.10.13...1.10.14
[1.10.13]: https://github.com/composer/composer/compare/1.10.12...1.10.13
[1.10.12]: https://github.com/composer/composer/compare/1.10.11...1.10.12
[1.10.11]: https://github.com/composer/composer/compare/1.10.10...1.10.11
[1.10.10]: https://github.com/composer/composer/compare/1.10.9...1.10.10
[1.10.9]: https://github.com/composer/composer/compare/1.10.8...1.10.9
[1.10.8]: https://github.com/composer/composer/compare/1.10.7...1.10.8
[1.10.7]: https://github.com/composer/composer/compare/1.10.6...1.10.7
[1.10.6]: https://github.com/composer/composer/compare/1.10.5...1.10.6
[1.10.5]: https://github.com/composer/composer/compare/1.10.4...1.10.5
[1.10.4]: https://github.com/composer/composer/compare/1.10.3...1.10.4
[1.10.3]: https://github.com/composer/composer/compare/1.10.2...1.10.3
[1.10.2]: https://github.com/composer/composer/compare/1.10.1...1.10.2
[1.10.1]: https://github.com/composer/composer/compare/1.10.0...1.10.1
[1.10.0]: https://github.com/composer/composer/compare/1.10.0-RC...1.10.0
[1.10.0-RC]: https://github.com/composer/composer/compare/1.9.3...1.10.0-RC
[1.9.3]: https://github.com/composer/composer/compare/1.9.2...1.9.3
[1.9.2]: https://github.com/composer/composer/compare/1.9.1...1.9.2
[1.9.1]: https://github.com/composer/composer/compare/1.9.0...1.9.1
[1.9.0]: https://github.com/composer/composer/compare/1.8.6...1.9.0
[1.8.6]: https://github.com/composer/composer/compare/1.8.5...1.8.6
[1.8.5]: https://github.com/composer/composer/compare/1.8.4...1.8.5
[1.8.4]: https://github.com/composer/composer/compare/1.8.3...1.8.4
[1.8.3]: https://github.com/composer/composer/compare/1.8.2...1.8.3
[1.8.2]: https://github.com/composer/composer/compare/1.8.1...1.8.2
[1.8.1]: https://github.com/composer/composer/compare/1.8.0...1.8.1
[1.8.0]: https://github.com/composer/composer/compare/1.7.3...1.8.0
[1.7.3]: https://github.com/composer/composer/compare/1.7.2...1.7.3
[1.7.2]: https://github.com/composer/composer/compare/1.7.1...1.7.2
[1.7.1]: https://github.com/composer/composer/compare/1.7.0...1.7.1
[1.7.0]: https://github.com/composer/composer/compare/1.7.0-RC...1.7.0
[1.7.0-RC]: https://github.com/composer/composer/compare/1.6.5...1.7.0-RC
[1.6.5]: https://github.com/composer/composer/compare/1.6.4...1.6.5
[1.6.4]: https://github.com/composer/composer/compare/1.6.3...1.6.4
[1.6.3]: https://github.com/composer/composer/compare/1.6.2...1.6.3
[1.6.2]: https://github.com/composer/composer/compare/1.6.1...1.6.2
[1.6.1]: https://github.com/composer/composer/compare/1.6.0...1.6.1
[1.6.0]: https://github.com/composer/composer/compare/1.6.0-RC...1.6.0
[1.6.0-RC]: https://github.com/composer/composer/compare/1.5.6...1.6.0-RC
[1.5.6]: https://github.com/composer/composer/compare/1.5.5...1.5.6
[1.5.5]: https://github.com/composer/composer/compare/1.5.4...1.5.5
[1.5.4]: https://github.com/composer/composer/compare/1.5.3...1.5.4
[1.5.3]: https://github.com/composer/composer/compare/1.5.2...1.5.3
[1.5.2]: https://github.com/composer/composer/compare/1.5.1...1.5.2
[1.5.1]: https://github.com/composer/composer/compare/1.5.0...1.5.1
[1.5.0]: https://github.com/composer/composer/compare/1.4.3...1.5.0
[1.4.3]: https://github.com/composer/composer/compare/1.4.2...1.4.3
[1.4.2]: https://github.com/composer/composer/compare/1.4.1...1.4.2
[1.4.1]: https://github.com/composer/composer/compare/1.4.0...1.4.1
[1.4.0]: https://github.com/composer/composer/compare/1.3.3...1.4.0
[1.3.3]: https://github.com/composer/composer/compare/1.3.2...1.3.3
[1.3.2]: https://github.com/composer/composer/compare/1.3.1...1.3.2
[1.3.1]: https://github.com/composer/composer/compare/1.3.0...1.3.1
[1.3.0]: https://github.com/composer/composer/compare/1.3.0-RC...1.3.0
[1.3.0-RC]: https://github.com/composer/composer/compare/1.2.4...1.3.0-RC
[1.2.4]: https://github.com/composer/composer/compare/1.2.3...1.2.4
[1.2.3]: https://github.com/composer/composer/compare/1.2.2...1.2.3
[1.2.2]: https://github.com/composer/composer/compare/1.2.1...1.2.2
[1.2.1]: https://github.com/composer/composer/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/composer/composer/compare/1.2.0-RC...1.2.0
[1.2.0-RC]: https://github.com/composer/composer/compare/1.1.3...1.2.0-RC
[1.1.3]: https://github.com/composer/composer/compare/1.1.2...1.1.3
[1.1.2]: https://github.com/composer/composer/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/composer/composer/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/composer/composer/compare/1.0.3...1.1.0
[1.1.0-RC]: https://github.com/composer/composer/compare/1.0.3...1.1.0-RC
[1.0.3]: https://github.com/composer/composer/compare/1.0.2...1.0.3
[1.0.2]: https://github.com/composer/composer/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/composer/composer/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/composer/composer/compare/1.0.0-beta2...1.0.0
[1.0.0-beta2]: https://github.com/composer/composer/compare/1.0.0-beta1...1.0.0-beta2
[1.0.0-beta1]: https://github.com/composer/composer/compare/1.0.0-alpha11...1.0.0-beta1
[1.0.0-alpha11]: https://github.com/composer/composer/compare/1.0.0-alpha10...1.0.0-alpha11
[1.0.0-alpha10]: https://github.com/composer/composer/compare/1.0.0-alpha9...1.0.0-alpha10
[1.0.0-alpha9]: https://github.com/composer/composer/compare/1.0.0-alpha8...1.0.0-alpha9
[1.0.0-alpha8]: https://github.com/composer/composer/compare/1.0.0-alpha7...1.0.0-alpha8
[1.0.0-alpha7]: https://github.com/composer/composer/compare/1.0.0-alpha6...1.0.0-alpha7
[1.0.0-alpha6]: https://github.com/composer/composer/compare/1.0.0-alpha5...1.0.0-alpha6
[1.0.0-alpha5]: https://github.com/composer/composer/compare/1.0.0-alpha4...1.0.0-alpha5
[1.0.0-alpha4]: https://github.com/composer/composer/compare/1.0.0-alpha3...1.0.0-alpha4
[1.0.0-alpha3]: https://github.com/composer/composer/compare/1.0.0-alpha2...1.0.0-alpha3
[1.0.0-alpha2]: https://github.com/composer/composer/compare/1.0.0-alpha1...1.0.0-alpha2
