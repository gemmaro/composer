### [2.8.4] 2024-12-11

  * `audit`コマンドの終了コードにあまり意味がなかった点を直しました（脆弱性があるときは1、放棄されたパッケージがあるときは2、両方のときは3になりました）
    (#12203)
  * プラグインで複数のクラスを定義したときの問題を修正しました (#12226)
  * phpの設定次第で、出力されるエラーの重複を直しました (#12214)
  * 一部のインスタンスで、InstalledVersionsが重複するデータを返していた点を直しました (#12225)
  * installed.phpで、整列が決定的になるように直しました (#12197)
  * 行内の制約を使ったときに、`bump-after-update`が失敗していた点を直しました (#12223)
  * `create-project`コマンドを修正し、パスレポジトリを引数として使うとき、シンボリックリンクが無効になるようにしました
    (#12222)
  * `validate --no-check-publish`を修正し、無関係なpublishのエラーを完全に隠し去りました (#12196)
  * composer auditが失敗したときに`audit`コマンドが失敗コードを返していた点を修正しました。
    このコマンドでビルドが失敗すべきではないからです。
    ともあれ、通常のビルドの一部でauditを実行するのは多分良くないでしょう (#12196)
  * curlの使い方を修正し、プロキシが使われているときに、壊れているバージョンでの多重化を無効にしました (#12207)

### [2.8.3] 2024-11-17

  * Windowsでのプロセス探索の扱いを修正 (#12180)
  * react/promiseの要件で2.xのインストールができるように改めて修正 (#12188)
  * lock:falseがrequireコマンドやbumpコマンドで設定されたときの問題を修正

### [2.8.2] 2024-10-29

  * プロバイダに説明がないとき、プロバイダの提案時にクラッシュしていた点を修正 (#12152)
  * 特定の状況で、スキーマに違反する固定ファイルが作られる問題を修正 (#12149)
  * 相対パスのリポジトリのパスを使う際に、2.8.1で生じた`create-project`の退行問題を修正 (#12150)
  * ctrl-Cで中断する操作が、テキストプロンプトで機能していなかった点を修正 (#12106)
  * 所有権の違反でgitによりリポジトリが読み込めなかったときに、gitがひとりでに失敗していた点を修正 (#12178)
  * プロキシを介してPHPでないバイナリを実行しているときの、シグナルの扱いを修正しました (#11716)

### [2.8.1] 2024-10-04

  * `init`コマンドを修正し、使用許諾が与えられなかったときの退行問題を修正しました (#12145)
  * `--strict-ambiguous`フラグの扱いを修正しました。
    全ての問題を報告しないことがありました (#12148)
  * `create-project`を修正し、インストールされるプロジェクトファイルのフォルダのパーミッションを継承するようにしました
    (#12146)
  * 親ディレクトリのcomposer.jsonを使うときのプロンプトが、正しく動かない場合があった点を修正しました (#8023)

### [2.8.0] 2024-10-02

  * 後方互換性についての警告：`https_proxy`環境変数が`http_proxy`の値にフォールバックする点を修正しました。
    2.7.3のリリースノートの通り、フォールバックと警告は削除されました (#11938, #11915)。
  * `update`コマンドに`--patch-only`フラグを追加しました。
    これにより、更新をパッチバージョンに制限し、全ての依存関係がより安全な方へ更新されます (#12122)
  * `audit`コマンドに`--abandoned`フラグに追加しました。
    放棄されたパッケージの扱い方が構成されます。
    `audit.abandoned`構成設定を上塗りします (#12091)
  * `audit`コマンドに`--ignore-severity`フラグを追加しました。
    1つ以上の勧告の深刻度を無視します (#12132)
  * `update`コマンドに`--bump-after-update`フラグを追加します。
    更新が完了した後にbumpを走らせます (#11942)
  * `scripts`のうち、どれが追加のCLIの引数を受け取るかを制御する方法を追加しました。
    また、コマンドのどこに入れるかも制御できます。
    [ドキュメント](https://getcomposer.org/doc/articles/scripts.md#controlling-additional-arguments)を参照してください
    (#12086)
  * `allow-missing-requirements`構成設定を追加しました。
    固定ファイルがcomposer.jsonの依存関係を満たさないときのエラーを飛ばすものです (#11966)
  * composer.lockファイルのJSONスキーマを追加しました (#12123)
  * Bitbucketのアプリパスワード対応を改善しました。
    リポジトリをクローンしたりソースからインストールしたりする部分です (#12103)
  * `reinstall`コマンドに`--type`フラグを追加し、種別でパッケージを絞り込めるようにしました (#12114)
  * `dump-autoload`コマンドに`--strict-ambiguous`フラグを追加しました。
    重複するクラスが見つかったときにエラーコードを返すようにします (#12119)
  * ベンダーファイルが削除されたときに`dump-autoload`で出す警告を加えました (#12139)
  * `create-project`を走らせる際、欠けている各プラットフォームパッケージに警告を追加しました。
    何度も走らせなくていいようにするためです (#12120)
  * `sort-packages`が有効のとき、allow-pluginsにパッケージの整列を追加しました (#11348)
  * extやlibのパッケージが欠けているときの、プロバイダパッケージやポリフィルの提案を追加しました (#12113)
  * 最初に全てのパッケージと取り得る更新情報を出力し、対話的なパッケージの更新の選択を改善しました (#11990)
  * 決定論的で（しばしば）論理的な方法で出力を整列し、依存関係の解決の失敗の出力を改善しました (#12111)
  * PHP 8.4の`E_STRICT`の非推奨の警告を修正しました (#12116)
  * `init`コマンドを修正し、与えられた使用許諾の識別子を検証するようにしました (#12115)
  * 機能パッケージが2つの主線ブランチのどちらかに由来する可能性があると思われるとき、バージョンの推定を、機能ブランチに基づいてより決定論的になるよう修正しました
    (#12129)
  * COMPOSER_ROOT_VERSION環境変数の扱いを修正しました。
    例えば1.1の扱いは1.2.x-devと同じにし、1.2.0とは違うようにしました (#12109)
  * requireコマンドを修正し、固定ファイルの新しい安定性フラグを飛ばすようにしました。
    以前は固定ファイルの不当な差分が生じていました (#12112)
  * php://stdin を修正しました。
    Composerをプラグラムで走らせているときに複数回開く可能性がありました (#12107)
  * プラットフォームパッケージの扱いを修正しました。
    why-notコマンドと部分更新の部分です (#12110)
  * 2.7.8で入った「transport-options.sslについて、ローカルの証明書の認証がロックファイルに保管されて、可搬でなかった点を修正しました
    (#12019)」が壊れていたため、差し戻しました。

### [2.7.9] 2024-09-04

  * 制約のある環境でのDockerの検出が壊れていた点を修正しました (#12095)
  * bash補完スクリプトの上流の問題を修正しました。
    `completion`コマンドで更新することをお勧めします (#12015)

### [2.7.8] 2024-08-22

  * `outdated`のJSON出力に`release-age`と`release-date`と`latest-release-date`を加えました
    (#12053)
  * PHP 8.4の非推奨の警告を修正しました。
  * ブランチを解決する部分を修正し、`#`記号を含むものでも機能するようにしました  (#12042)
  * `bump`コマンドについて、`~`制約が正しく扱われていなかった点を直しました (#11889)
  * COMPOSER_AUTHが./auth.jsonより優先度が上でなかった点を修正しました (#12084)
  * `relative: true`について、パスのリポジトリのシンボリックリンクが考慮されないことがあった点を修正しました (#12092)
  * キャッシュからの複製について、VirtualBoxの共有フォルダを使うときに失敗することがあった点を修正しました (#12057)
  * PSR-4の自動読み込み順序について、エッジケースの退行問題を修正しました (#12063)
  * 重複するlib-*パッケージにより、peclとcoreのバージョンの同じPHP拡張があるときに問題が生じていた点を修正しました (#12093)
  * transport-options.sslについて、ローカルの証明書の認証がロックファイルに保管されて、可搬でなかった点を修正しました
    (#12019)
  * メモリに関して、大きなバイナリをインストールするときの問題を修正しました (#12032)
  * `archive`コマンドについて、windowsでパスのrealpathが取れないときにクラッシュする点を修正しました (#11544)
  * API: BasePackage::STABILITIESをもって、BasePackage::$stabilitiesを廃止しました
    (685add70ec)
  * Dockerの検出を改善しました (#12062)

### [2.7.7] 2024-06-10

  * セキュリティ：悪意のあるgitブランチ名を介したコマンドインジェクションに対して修正しました (GHSA-47f6-5gq3-vx9c /
    CVE-2024-35241)。
  * セキュリティ：悪意のあるgit/hgブランチ名を介した複数のコマンドインジェクションに対して修正しました
    (GHSA-v9qv-c7wm-wgmf / CVE-2024-35242)。
  * セキュリティ：不正なURLの形式を使って迂回される可能性のあったsecure-http検査を修正しました (fa3b9582c)。
  * セキュリティ：linuxにおけるwindows固有の検査を含むFilesystem::isLocalPathを修正しました
    (3c37a67c)。
  * セキュリティ：perforceへの引数のエスケープを修正しました (3773f775)。
  * セキュリティ：アーカイブを解凍するときのzip爆弾の扱いを修正しました (de5f7e32)。
  * セキュリティ：Windowsのコマンドの仮引数のエスケープを修正し、エンコーディングの変換の最尤一致によるユニコード文字の濫用を防止しました
    (3130a7455, 04a63b324)。
  * 隠された規則の名前空間に合致しないクラスに対するPSR違反を修正しました。
    これにより新たに違反項目が見つかるかもしれません (#11957)。
  * プラグインがベンダーディレクトリにあるものの、ブランチを変えた後に必要でなくなったり使えなくなったりしたときのUXを修正しました
    (#12000)。
  * 固定ファイルが古いとき、composer.jsonの新しいプラットフォーム要件が検査されない点を修正しました (#12001)。
  * `config`コマンドがautoloadキーを削除する機能を修正しました (#11967)。
  * `init`コマンドでの空の`type`への対応を修正しました (#11999)。
  * gitの構成で`safe.bareRepository`が`strict`に設定されているときのgitクローンのエラーを修正しました
    (#11969)。
  * PHP <8.1でネットワークエラーが表示される退行問題を修正しました (#11974)。
  * 一部の警告でのカラーブリードを修正しました (#11972)。

### [2.7.6] 2024-05-04

  * スクリプト制御子が私有コールバックを使う自動読み込み器を加えるときの退行問題を修正しました (#11960)。

### [2.7.5] 2024-05-03

  * `remove`コマンドに`uninstall`の別称を加えました (#11951)。
  * 転送で例外を起こすcurlの壊れたバージョン8.7.0/8.7.1のための対処法を加えました (#11913)。
  * Podmanコンテナ内で表示される、rootを使うときの警告を修正しました (#11946)。
  * configコマンドがある状況で正しくオブジェクトを扱っていなかった点を修正しました (#11945)。
  * プロジェクトディレクトリがシンボリックリンクのとき、バイナリプロキシが正しいパスを含んでいなかった点を修正しました (#11947)。
  * イベント制御子（scriptsとplugins）から読み込まれたときに、Composerの自動読み込み器がプロジェクトの自動読み込み器から無視される点を修正しました
    (#11955)。
  * TransportException（httpの失敗）が個別の終了コードでなかった点を修正しました (#11954)。
    `100`のコードで終わるようになりました。

### [2.7.4] 2024-04-22

  * composer/composerのバージョンpre-2.7.3を要件とするプロジェクトでの退行問題（`Call to undefined
    method ProxyManager::needsTransitionWarning()`）を修正しました (#11943, #11940)。

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
  * 固定ファイルが存在していない場合に`require`コマンドが最後にクラッシュする問題を修正しました (#11814)。
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

### [2.6.4] 2023-09-29

  * セキュリティ：composer.pharが公開されててアクセスでき、PHPとして実行でき、php.iniでregister_argc_argvが有効なとき、遠隔コード実行の脆弱性がありえた点を直しました
    (GHSA-jm6m-4632-36hf / CVE-2023-43655)。
  * auditコマンドで放棄されたパッケージのjson出力を直しました (#11647)。
  * プール最適化の工程を効率良くしました (#11638)。
  * `show -a <パッケージ名>`の効率良くしました (#11659)。

[2.8.4]: https://github.com/composer/composer/compare/2.8.3...2.8.4
[2.8.3]: https://github.com/composer/composer/compare/2.8.2...2.8.3
[2.8.2]: https://github.com/composer/composer/compare/2.8.1...2.8.2
[2.8.1]: https://github.com/composer/composer/compare/2.8.0...2.8.1
[2.8.0]: https://github.com/composer/composer/compare/2.7.9...2.8.0
[2.7.9]: https://github.com/composer/composer/compare/2.7.8...2.7.9
[2.7.8]: https://github.com/composer/composer/compare/2.7.7...2.7.8
[2.7.7]: https://github.com/composer/composer/compare/2.7.6...2.7.7
[2.7.6]: https://github.com/composer/composer/compare/2.7.5...2.7.6
[2.7.5]: https://github.com/composer/composer/compare/2.7.4...2.7.5
[2.7.4]: https://github.com/composer/composer/compare/2.7.3...2.7.4
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
