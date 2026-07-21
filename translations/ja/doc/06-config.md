# 構成

本章では`composer.json`の[スキーマ](04-schema.md)の`config`節について記述していきます。

## process-timeout

プロセス実行の制限時間で、秒単位です。
既定では300（5分）です。
`git clone`のような時間の掛かるプロセスは、Composerによりプロセスの異常終了が推定されるまで、実行できます。
接続が遅い場合やベンダーが大きい場合は、これを増やす必要があるかもしれません。

例：

```json
{
    "config": {
        "process-timeout": 900
    }
}
```

### 個々のスクリプトのコマンドで制限時間を無効にする

`scripts`以下の独自コマンドでプロセスの制限時間を無効にするには、静的ヘルパーが使えます。

```json
{
    "scripts": {
        "test": [
            "Composer\\Config::disableProcessTimeout",
            "phpunit"
        ]
    }
}
```

## allow-plugins

既定は`{}`で、1つもプラグインを読み込むことはできません。

Composer
2.2.0では、`allow-plugins`オプションによってセキュリティの層が追加され、Composerの実行中にどのComposerプラグインがコードを実行できるかを制限できるようになりました。

新しいプラグインが最初に活性化され、それが構成オプションにまだ挙げられていなければ、Composerは警告を印字します。
Composerを対話的に実行すると、プラグインを実行するかどうかを決めるようプロンプトを出します。

この設定を使うと、信頼できるパッケージのみがコードを実行できるようになります。
パッケージ名パターンをキーに持つオブジェクトに設定します。
値は、許可する場合は**true**で、許可しない場合は**false**です。
何れもこれ以外の警告とプロンプトは抑制されます。

```json
{
    "config": {
        "allow-plugins": {
            "third-party/required-plugin": true,
            "my-organization/*": true,
            "unnecessary/plugin": false
        }
    }
}
```

構成オプション自体を`false`にして全てのプラグインを拒否したり、`true`にして全てのプロラグインが走るのを許可したり（全くお勧めしません）するようにも設定できます。
例えば以下の通りです。

```json
{
    "config": {
        "allow-plugins": false
    }
}
```

## use-include-path

既定では`false`です。
`true`にすると、Composerの自動読み込み器はPHPのインクルードパスにあるクラスも探します。

## preferred-install

既定では`dist`で、`source`、`dist`、`auto`の何れかです。
このオプションではComposerが優先して使うインストール方法を設定できます。
お好みで、より柔軟なインストール設定のためにキーにパッケージ名のパターンがあるオブジェクトにすることもできます。

```json
{
    "config": {
        "preferred-install": {
            "my-organization/stable-package": "dist",
            "my-organization/*": "source",
            "partner-organization/*": "auto",
            "*": "dist"
        }
    }
}
```

- `source`は、Composerが（存在する場合）`source`からパッケージをインストールすることを意味します。
  通常、git cloneまたは同等のパッケージが使用するバージョン管理システムのチェックアウトです。
  プロジェクトにバグ修正を行い、依存関係のローカルgitクローンを直接取得する場合に便利です。
- `auto`は遺物的な動作です。
  開発バージョンの場合にComposerは`source`を自動的に使用し、それ以外の場合は`dist`を使用します。
- `dist`（Composer 2.1以降で既定）は、可能であればComposerが`dist`からインストールすることを意味します。
  通常、zipファイルのダウンロードであり、リポジトリ全体のクローンよりも高速です。

> **補足：** 順番は重要です。
> より限定されたパターンは、より緩いパターンの前に来るべきです。
> 大域構成やパッケージ構成で文字列表記とハッシュ構成を混在させると、文字列表記は`*`パッケージパターンに解釈されます。

> **Tip:** If you want a source checkout for some packages so you can make
> local edits, but only on your own machine (not in CI), prefer configuring
> `preferred-install` globally rather than committing it to the project. For
> example:
>
> ```
> composer config --global preferred-install.my-vendor/* source
> ```
>
> CI then keeps installing from `dist` by default, while your dev machine
> always pulls those packages from source. This avoids relying on a source
> install failure to fall back to dist, and saves CI from attempting a clone
> first, which keep the output leaner and your CI faster.

## source-fallback

> **Deprecated:** This option is deprecated and will be removed in Composer 2.11.
> Do not set it unless you absolutely need to. It exists as a temporary opt-in
> while we disable the dist → source fallback for security reasons (silently
> switching from a dist to a less-trusted or manipulated source checkout has
> security implications). If you have a legitimate use case for re-enabling
> the dist → source fallback and do not want us to remove it in 2.11, please
> open an issue at https://github.com/composer/composer/issues to let us know.

Defaults to `false`. When set to `true`, a failed **dist** install will fall
back to a **source** checkout. This option only governs the dist → source
direction; falling back from a failed source checkout to the dist artifact
is always allowed regardless of this setting.

```json
{
    "config": {
        "source-fallback": true
    }
}
```

> **補足：**
> このオプションが既定値 (`false`) にありdistのダウンロードが失敗するなら、
> Composerはソースのチェックアウトを試みる代わりに直ちにエラーを投げます。
> 希望のインストールソース (`preferred-install`) が正しく構成されていることをご確認ください。

## policy

Unified dependency policy configuration. Controls Composer behavior for
dependencies with security advisories, flagged as malware, abandoned
packages, and custom dependency policies. Audit reports can be generated
with `composer audit`; blocking prevents insecure or otherwise flagged
package versions from being installed during `composer update`, `require`,
or `remove` and malware also during a `composer install`.

`false`に設定するとすべての依存関係のポリシーの促進が無効になります。

```json
{
    "config": {
        "policy": false
    }
}
```

> **`config.audit`からの移行ですか？**
> 移行の際に以前のキーがどのように今なおフォールバックとして尊重されているかについては、[どのように`config.audit`が`config.policy`と対応するか](#how-config-audit-interacts-with-config-policy)を参照。

### advisories

セキュリティの勧告により影響を受けるパッケージのための構成です。

#### block

既定で`true`です。
`true`のとき、その勧告かパッケージが無視されない限りは、活性なセキュリティ勧告付きのパッケージは遮断され`update`/`require`/`remove`の間にインストールできません。

```json
{
    "config": {
        "policy": {
            "advisories": {
                "block": false
            }
        }
    }
}
```

#### audit

Defaults to `fail`. How `composer audit` treats packages with security
advisories.

- `ignore`は、勧告が報告されません
- `report`では、勧告は報告されるものの非ゼロの終了コードになりません。
- `fail`では、勧告により`composer audit`に非ゼロコードの失敗が引き起こされます。

```json
{
    "config": {
        "policy": {
            "advisories": {
                "audit": "report"
            }
        }
    }
}
```

#### ignore-id

A list of advisory IDs (CVE, GHSA, PKSA, …) to ignore. Each entry can
optionally include a reason and scoping (`on-block`/`on-audit`) to limit
where the ignore applies.

##### 単純なリスト：

```json
{
    "config": {
        "policy": {
            "advisories": {
                "ignore-id": ["CVE-1234", "GHSA-xx"]
            }
        }
    }
}
```

##### 理由付き：

```json
{
    "config": {
        "policy": {
            "advisories": {
                "ignore-id": {
                    "CVE-1234": "Not affected.",
                    "GHSA-xx": "Patch applied."
                }
            }
        }
    }
}
```

##### スコープ付き：

`on-block: false` means the advisory no longer blocks updates but is still
reported in audit.  `on-audit: false` means the advisory still blocks
updates but is no longer reported in audit.

```json
{
    "config": {
        "policy": {
            "advisories": {
                "ignore-id": {
                    "CVE-1234": {"on-block": false, "reason": "Patch applied, still want blocking."},
                    "GHSA-xx":  {"on-audit": false, "reason": "False positive, still report."}
                }
            }
        }
    }
}
```

#### ignore

A list of package names to ignore for security advisory handling. Supports
wildcards and optional version constraints. See the [ignore
format](#ignore-format) for all supported syntax variants.

#### ignore-severity

無視する勧告のセキュリティの水準のリストであり、`low`、`medium`、`high`、`critical`の何れかです。

##### 単純なリスト：

```json
{
    "config": {
        "policy": {
            "advisories": {
                "ignore-severity": ["low", "medium"]
            }
        }
    }
}
```

##### スコープ付き：

```json
{
    "config": {
        "policy": {
            "advisories": {
                "ignore-severity": {
                    "low":    {"on-block": false},
                    "medium": {"on-audit": false, "reason": "Handled via WAF"}
                }
            }
        }
    }
}
```

### abandoned

放棄されたパッケージ用の構成です。

#### block

Defaults to `false`. When `true`, abandoned packages cannot be installed
during `update`/`require`/`remove`.

```json
{
    "config": {
        "policy": {
            "abandoned": {
                "block": true
            }
        }
    }
}
```

#### audit

既定で`fail`です。
どのように`composer audit`が放棄されたパッケージを扱うかを決めます。

- `ignore`は、放棄されたパッケージが報告されません
- `report`では、放棄されたパッケージが報告されるものの非ゼロコードの終了を引き起こしません。
- `fail`では、放棄されたパッケージにより`composer audit`は非ゼロのコードでの終了が引き起こされます。

```json
{
    "config": {
        "policy": {
            "abandoned": {
                "audit": "report"
            }
        }
    }
}
```

[`COMPOSER_AUDIT_ABANDONED`](03-cli.md#composer-audit-abandoned)環境変数または[`--abandoned`](03-cli.md#audit)
CLIオプションを介してオーバーライドできます。

#### ignore

A list of package names (or patterns) to ignore for the abandoned check,
regardless of their abandoned state. See the [ignore format](#ignore-format)
for all supported syntax variants.

```json
{
    "config": {
        "policy": {
            "abandoned": {
                "ignore": {
                    "acme/*": "Scheduled for replacement next quarter.",
                    "vendor/legacy": {"on-block": false, "reason": "Allow in updates but still report."}
                }
            }
        }
    }
}
```

### malware

マルウェアを含むものとして旗が立ったパッケージのバージョンのための構成です。

#### block

既定で`true`です。
`true`のとき、マルウェアとして旗が立ったパッケージのバージョンは遮断されます。

#### block-scope

既定で`all`です。
これはどのコマンドが阻害のきっかけとなるかを制御するものです。

- `all`では、`update`/`require`/`remove`と`install`の両方の間に阻害します
- `update`では、`update`/`require`/`remove`の間でのみ阻害します
- `install`では、`install`の間でのみ阻害します

```json
{
    "config": {
        "policy": {
            "malware": {
                "block-scope": "update"
            }
        }
    }
}
```

#### audit

既定で`fail`です。
[advisories.audit](#audit)と同じ値です。

#### ignore

Package names to exclude from malware checks. See the [ignore
format](#ignore-format) for all supported syntax variants.

#### ignore-source

マルウェアの検査から除かれるソースの名前のリストです。

```json
{
    "config": {
        "policy": {
            "malware": {
                "ignore-source": ["aikido"]
            }
        }
    }
}
```

### ignore-unreachable

Defaults to `["update", "install"]`. When the operation is listed here,
repositories and policies with URL sources that are unreachable or return a
non-200 response are silently ignored rather than causing an error. Useful
in environments where not all package repositories are accessible.

Set to `true` to ignore unreachable repositories and custom dependency
policy sources for all operations and to `false` to ignore them for no
operations. Possible values are: `audit`, `install`, and `update`.

```json
{
    "config": {
        "policy": {
            "ignore-unreachable": ["install", "update", "audit"]
        }
    }
}
```

### 独自の依存関係のポリシー

In addition to the built-in `advisories`, `malware`, and `abandoned`
dependency policies, you can define named custom dependency policies. A
custom dependency policy needs its own set of package versions, supplied by
one or more sources (advertised by package repositories or set explicitly
here).

```json
{
    "config": {
        "policy": {
            "my-policy": {
                "block": true,
                "audit": "fail",
                "sources": [
                    {"type": "url", "url": "https://example.org/my-bad-packages-list.json"}
                ],
                "ignore": {
                    "vendor/package": "Assessed and accepted."
                }
            }
        }
    }
}
```

Source URLs must use `https://`. `http://` and other schemes are rejected
both at schema validation time (`composer validate`) and at config load
time.

A `url` source is queried the same way as a repository's
[`api-url`](05-repositories.md#filter): Composer sends a POST request with
the relevant package PURLs and the custom dependency policy name, and
expects the matching filter entries back. The request is not cached
client-side because each request body is different. Implementors should be
aware that large amounts (a few hundred would be normal) of package names
can be submitted. The submitted PURLs are the full set of candidate package
names gathered *before* dependency resolution, so they identify packages by
name only (no version constraints yet), and not every submitted package will
necessarily be selected by the resolver afterwards.

エンドポイントは以下の形式のJSONの本文を受け取ります。

```json
{
    "packages": ["pkg://composer/vendor/package", "pkg://composer/other/package"],
    "lists": ["my-policy"]
}
```

The request body reuses the wire format of a Composer repository's
[`api-url`](05-repositories.md#filter).  There, a single endpoint can serve
several named filter lists (for example `malware` and `typosquatting`), so
`lists` is an array naming which of them Composer wants, and the response is
a `filter` object keyed by list name. A custom dependency policy has no such
multiplexing: its `url` source exists only to serve that one
policy. Composer therefore always sends the policy name as the sole element
of `lists` (so the array carries exactly one value here), and the endpoint
should treat any list name it receives as referring to that policy.

要約エンドポイントは以下の形式のJSONを返さなければなりません。

```json
{
    "filter": [
        {
            "package": "vendor/package",
            "constraint": ">=1.0.0,<1.2.0",
            "url": "https://example.org/filters/123",
            "reason": "Assessed and rejected.",
            "id": "PKFE-xxxx-xxxx-xxxx"
        }
    ]
}
```

Because the `url` source only ever serves this one policy, the response
drops the per-list keying used by a repository's `api-url` (where `filter`
is an object mapping each requested list name to its entries). Here `filter`
is instead a flat array of entries that all belong to this policy. The
`package` and `constraint` fields are required on each entry; `url`,
`reason`, and `id` are optional.  Entries whose package does not match a
package in the request are ignored.

Custom dependency policy names must not conflict with the reserved names
`advisories`, `malware`, or `abandoned`, and must not start with `ignore`
(the only `ignore`-prefixed key allowed at this level is the documented
`ignore-unreachable` setting).

The following names are reserved for future built-in dependency policies and
cannot be used as custom dependency policy names: `package`, `packages`,
`license`, `licence`, `licenses`, `licences`, `support`, `maintenance`,
`security`, `minimum-release-age`. Composer rejects any colliding key both
at schema validation time (`composer validate`) and at config load time.

### ignoreの形式

The `ignore` key on every dependency policy accepts package name patterns
with optional version constraints and per-rule scoping. All formats may be
mixed in the same map.

##### 単純なリスト（すべてのバージョンを無視）：

```json
{
    "config": {
        "policy": {
            "<policy>": {
                "ignore": ["vendor/package", "acme/*"]
            }
        }
    }
}
```

##### 理由付き：

```json
{
    "config": {
        "policy": {
            "<policy>": {
                "ignore": {
                    "vendor/package": "Assessed, no risk."
                }
            }
        }
    }
}
```

##### パッケージ制約付き：

```json
{
    "config": {
        "policy": {
            "<policy>": {
                "ignore": {
                    "vendor/package": {"constraint": "^2.0", "reason": "Only v2 is affected."}
                }
            }
        }
    }
}
```

##### スコープ付き：

`on-block: false` ignores only for audit (the package is still blocked
during updates as on-block ignoring is disabled).  `on-audit: false` ignores
only for blocking (the package is still reported in audit).

```json
{
    "config": {
        "policy": {
            "<policy>": {
                "ignore": {
                    "vendor/package": {"on-audit": false, "reason": "Workaround applied; keep reporting."}
                }
            }
        }
    }
}
```

##### 同じパッケージのための複数の規則：

```json
{
    "config": {
        "policy": {
            "<policy>": {
                "ignore": {
                    "vendor/package": [
                        {"constraint": "^1.0", "on-audit": false},
                        {"constraint": "^2.0", "reason": "v2 is patched."}
                    ]
                }
            }
        }
    }
}
```

## audit

> **Deprecated.** Use [`config.policy`](#policy) instead. All `config.audit` keys are still
> supported for backwards compatibility but will be removed in a future major version.

セキュリティの監査とバージョンの遮断の構成オプションです。
監査の報告は`composer audit`で生成でき、短い形式のものは自動でupdateないしrequireコマンドの末尾で報告されます。
バージョンの遮断では、安全でなかったり放棄されたりしているものと確認されたパッケージのバージョンを、構成に応じて、依存関係を解決する前に無視します。
これにより、そうしたパッケージがインストールされないようにします。

### `config.audit`はどのように`config.policy`と相互作用するか

The legacy `config.audit` keys are only read as a fallback when the
corresponding [`config.policy`](#policy) section is **absent**. The fallback
is all-or-nothing per built-in dependency policy:

- If [`config.policy.advisories`](#advisories) is set (to any value,
  including `false`), every advisories-related `audit.*` key
  ([`audit.block-insecure`](#block-insecure), [`audit.ignore`](#ignore-3),
  [`audit.ignore-severity`](#ignore-severity-1)) is **ignored entirely** —
  only [`policy.advisories.block`](#block),
  [`policy.advisories.ignore`](#ignore), and
  [`policy.advisories.ignore-severity`](#ignore-severity) are
  read. Mix-and-matching, e.g. setting `policy.advisories.block` while
  expecting `audit.ignore-severity` to still apply, is not
  supported. Migrate all advisories-related settings together.
- If [`config.policy.abandoned`](#abandoned) is set (to any value, including
  `false`), every abandoned-related `audit.*` key
  ([`audit.block-abandoned`](#block-abandoned),
  [`audit.abandoned`](#abandoned-1),
  [`audit.ignore-abandoned`](#ignore-abandoned)) is **ignored entirely** —
  only [`policy.abandoned.block`](#block-1),
  [`policy.abandoned.audit`](#audit-1), and
  [`policy.abandoned.ignore`](#ignore-1) are read.
- The two built-in dependency policies are independent: configuring
  `policy.advisories` while leaving the abandoned settings under `audit.*`
  is allowed and vice versa.
- Setting [`policy.ignore-unreachable`](#ignore-unreachable) supersedes the
  legacy [`audit.ignore-unreachable`](#ignore-unreachable-1) key.

### ignore

> **Deprecated.** Use [`config.policy.advisories.ignore-id`](#ignore-id) for advisory IDs
> (CVE, GHSA, PKSA) and [`config.policy.advisories.ignore`](#ignore) for package names instead.
> Note: the new format uses `on-block`/`on-audit` booleans instead of `"apply": "audit|block|all"`.

勧告の識別子、リモートの識別子、CVEの識別子、パッケージ名（非推奨）のリストです。
これらは監査の報告やバージョンの遮断からは無視されます。

#### 理由付きの単純な形式：

```json
{
    "config": {
        "audit": {
            "ignore": {
                "CVE-1234": "The affected component is not in use.",
                "GHSA-xx": "The security fix was applied as a patch.",
                "PKSA-yy": "Due to mitigations in place the update can be delayed."
            }
        }
    }
}
```

#### 理由のない単純な形式：

```json
{
    "config": {
        "audit": {
            "ignore": ["CVE-1234", "GHSA-xx", "PKSA-yy"]
        }
    }
}
```

#### 適用範囲付きの詳細な形式：

詳細な形式では、無視するための構成が、監査の報告だけか、バージョンの遮断のみか、あるいはその両方かを制御できるようにします。
`apply`フィールドは
- `audit` - 監査の報告だけ無視します
  （勧告は監査の報告に現れませんが、パッケージは更新するときに遮断されます）
- `block` - バージョンの遮断のみ無視します
  （パッケージは更新中のみ使えますが、勧告は監査の報告に現れます）
- `all` - 監査の報告とバージョンの遮断のときに無視されます（既定の動作）

```json
{
    "config": {
        "audit": {
            "ignore": {
                "CVE-1234": {
                    "apply": "audit",
                    "reason": "Not applicable to us, so don't report, but still want to make sure we don't use this version in updates."
                },
                "GHSA-xx": {
                    "apply": "block",
                    "reason": "Workaround applied, can only fix next week, allow during updates but still report in audits"
                },
                "PKSA-yy": {
                    "apply": "all",
                    "reason": "False report, Ignore completely in all contexts"
                }
            }
        }
    }
}
```

これら全ての形式は同じ構成に混ぜて使えます。

### abandoned

> **非推奨です。**
> [`config.policy.abandoned.audit`](#audit-1)を代用してください。

Composer 2.7以降、既定で`fail`です（このオプションが追加されたComposer 2.6では既定で`report`でした）。
監査コマンドが放棄されたパッケージを報告するかどうかを定義するもので、3つの値を取り得ます。

- `ignore`では、監査の報告で放棄されたパッケージを全く考慮しません。
- `report`では、放棄されたパッケージが失敗として報告されるものの、composerの監査コマンドは非ゼロコードで終了しません。
- `fail`では、放棄されたパッケージにより監査コマンドが非ゼロコードで失敗します。

なお、これは監査の報告にのみ適用されます。
この設定は安全でないパッケージの阻止には効果がありません。
放棄されたパッケージの阻止を構成するには、[`block-abandoned`](#block-abandoned)オプションを参照。

```json
{
    "config": {
        "audit": {
            "abandoned": "report"
        }
    }
}
```

Composer
2.7以降、[`COMPOSER_AUDIT_ABANDONED`](03-cli.md#composer-audit-abandoned)環境変数を介して、オプションをオーバーライドできます。

Composer
2.8以降、[`--abandoned`](03-cli.md#audit)コマンドラインオプションを介して、オプションをオーバーライドできます。
このオプションにより、構成値と環境変数が共にオーバーライドされます。

### ignore-abandoned

> **Deprecated.** Use [`config.policy.abandoned.ignore`](#ignore-1) instead.
> Note: the new format uses `on-block`/`on-audit` booleans instead of `"apply": "audit|block|all"`.

放棄されたパッケージ名のリストで、監査の報告やバージョンの遮断で無視されます。
放棄された状態であっても使い続けたいパッケージを選ぶことができます。

#### 理由付きの単純な形式：

```json
{
    "config": {
        "audit": {
            "ignore-abandoned": {
                "acme/*": "Work scheduled for removal next month.",
                "acme/package": "Transitive dependency but unreachable and not in active use within our project context."
            }
        }
    }
}
```

#### 理由のない単純な形式：

```json
{
    "config": {
        "audit": {
            "ignore-abandoned": ["acme/*", "acme/package"]
        }
    }
}
```

#### 適用範囲付きの詳細な形式：

詳細な形式では、無視する設定が、監査の報告のみか、バージョンの遮断のみか、あるいはその両方に適用されるかを制御できます。
`apply`フィールドは以下を受け付けます。
- `audit` - 監査の報告のみ無視します

（パッケージは監査の報告に現れませんが、[`block-abandoned`](#block-abandoned)が有効のときは更新のときに遮断されます）
- `block` - バージョンの遮断のみ無視します
  （[`block-abandoned`](#block-abandoned)が有効でもパッケージは更新のときに使えます。
  ただし監査の報告には現れます）
- `all` - 監査の報告とバージョンの遮断を無視します（既定の動作）

```json
{
    "config": {
        "audit": {
            "ignore-abandoned": {
                "acme/package": {
                    "apply": "block",
                    "reason": "Allow during updates but still report as abandoned"
                },
                "vendor/*": {
                    "apply": "all",
                    "reason": "We maintain these packages internally"
                }
            }
        }
    }
}
```

これら全ての形式は同じ構成に混ぜて使えます。

### ignore-severity

> **Deprecated.** Use [`config.policy.advisories.ignore-severity`](#ignore-severity) instead.
> Note: the new format uses `on-block`/`on-audit` booleans instead of `"apply": "audit|block|all"`.

既定は`[]`です。
監査の報告やバージョンの遮断で無視されるセキュリティ水準のリストです。

#### 単純な形式：

```json
{
    "config": {
        "audit": {
            "ignore-severity": ["low", "medium"]
        }
    }
}
```

#### 適用範囲付きの詳細な形式：

詳細な形式では、無視する構成が、監査の報告のみか、バージョンの遮断のみか、あるいはその両方に適用されるかを制御できます。
`apply`フィールドは以下を受け付けます。
- `audit` - 監査の報告のみ無視します
  （この厳密さの勧告は監査の報告に現れませんが、パッケージは更新のとき遮断されます）
- `block` - バージョンの遮断のみ無視します
  （パッケージは更新のときは使えますが、この厳密さの勧告は監査の報告で現れます）
- `all` - 監査と遮断の両方で無視されます（既定の動作）

```json
{
    "config": {
        "audit": {
            "ignore-severity": {
                "low": {
                    "apply": "all"
                },
                "medium": {
                    "apply": "block"
                }
            }
        }
    }
}
```

これら全ての形式は同じ構成に混ぜて使えます。

### ignore-unreachable

> **非推奨です。**
> [`config.policy.ignore-unreachable`](#ignore-unreachable)を代用してください。

既定で`false`です。
到達できないリポジトリは`composer audit`のときに無視されます。
全てのリポジトリはアクセスできない環境でコマンドを実行するときに役立つことがあります。
この設定は`composer audit`コマンド以外のところで生成されたバージョンの遮断や監査の報告には適用されません。

```json
{
    "config": {
        "audit": {
            "ignore-unreachable": true
        }
    }
}
```

### block-insecure

> **非推奨です。**
> [`config.policy.advisories.block`](#block)を代用してください。

既定で`true`です。
`true`のとき、セキュリティ勧告が無視されていなければ、セキュリティ勧告の影響を受けるパッケージのバージョンは遮断され、composer
update/require/deleteコマンドで使えません。
[`block-abandoned`](#block-abandoned)が有効であれば、バージョンの遮断では、放棄されたパッケージの使用も防ぎます。

```json
{
    "config": {
        "audit": {
            "block-insecure": false
        }
    }
}
```

### block-abandoned

> **非推奨です。**
> [`config.policy.abandoned.block`](#block-1)を代用してください。

既定で`false`です。
`true`のとき、放棄されたパッケージはcomposerのupdate/required/deleteコマンドで使えません。
[`block-insecure`](#block-insecure)が偽に設定されてバージョンの遮断が無効になっていないときにのみ適用されます。


```json
{
    "config": {
        "audit": {
            "block-abandoned": true
        }
    }
}
```

## use-parent-dir

composer.jsonがないディレクトリでComposerを実行しており、その上のディレクトリにcomposer.jsonがある場合、Composerは既定で、そのディレクトリのcomposer.jsonを代わりに使用するかどうかを尋ねます。

このプロンプトに対して常に「はい」と答えたい場合は、この構成値を`true`に設定できます。
プロンプトが表示されないようにするには、`false`に設定します。
既定は`"prompt"`です。

> **補足：** この構成を機能させるには、大域的な利用者全体の構成で設定しなければなりません。
> 例えば`php composer.phar config --global use-parent-dir true`を使用して設定します。

## store-auths

認証のプロンプトの後にする動作です。
`true`（常に保存する）、`false`（保存しない）、`"prompt"`（毎回確認する）の何れか1つで、既定では`"prompt"`です。

## github-protocols

既定では`["https", "ssh", "git"]`です。
github.comからクローンを作成するときに使用するプロトコルのリストで、優先度順に並べます。
既定では`git`が存在しますが、gitプロトコルは暗号化されていないため、[secure-http](#secure-http)が無効になっている場合のみ使われます。
originのリモートプッシュURLでssh (`git@github.com:...`)
ではなくhttpsを使用する場合、プロトコルリストを`["https"]`のみに設定すると、ComposerはプッシュURLをSSHのURLに上書きすることを取り止めます。

## github-oauth

ドメイン名とoauthキーのリストです。
たとえば、このオプションの値として`{"github.com":
"oauthtoken"}`を使用すると、`oauthtoken`を使用してgithubの私有リポジトリにアクセスし、APIのIPに基づく低いレート制限を回避します。
Composerは、必要に応じて資格情報を要求する場合がありますが、これらは手動で設定することもできます。
GitHubのOAuthトークンを取得する方法及びcliの構文の詳細については、[こちら](articles/authentication-for-private-packages.md#github-oauth)を参照してください。

## gitlab-domains

既定では`["gitlab.com"]`です。
GitLabサーバーのドメインのリストです。
`gitlab`リポジトリ種別を使う場合に使用されます。

## gitlab-oauth

ドメイン名とoauthキーのリストです。
たとえば、このオプションの値として`{"gitlab.com":
"oauthtoken"}`を使用すると、`oauthtoken`を使用してgitlabの私有リポジトリにアクセスします。
なお、パッケージがgitlab.comでホストされていない場合、ドメイン名も[`gitlab-domains`](06-config.md#gitlab-domains)オプションで指定する必要があります。
詳細情報は[こちら](articles/authentication-for-private-packages.md#gitlab-oauth)にもあります。

## gitlab-token

ドメイン名と私有トークンのリストです。
私有トークンは、単純な文字列、または利用者名とトークンを含む配列の何れかです。
たとえば、このオプションの値として`{"gitlab.com": "privatetoken"}`を使用すると、`privatetoken`を使用してgitlabの私有リポジトリにアクセスします。
`{"gitlab.com": {"username": "gitlabuser", "token": "privatetoken"}}`を使用すると、利用者名とトークンの両方を使ってgitlabのデプロイトークン機能 (https://docs.gitlab.com/ ee/user/project/deploy_tokens/) を使用します。
なお、パッケージがgitlab.comでホストされていない場合、ドメイン名も[`gitlab-domains`](06-config.md#gitlab-domains)オプションで指定する必要があります。
トークンには`api`または`read_api`スコープが必要です。
詳細情報は[こちら](articles/authentication-for-private-packages.md#gitlab-token)にもあります。

## gitlab-protocol

パッケージメタデータの`source`値用にリポジトリのURLを作成するときに、強制的に使用するプロトコルです。
`git`または`http`の何れかです（`https`は`http`の同義語として扱われます）。
HTTPベーシック認証を使った[GitLabのCI_JOB_TOKEN](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-reference)により、後々GitLab
CIのジョブでクローンされる私有リポジトリを参照するプロジェクトを扱う際に役立ちます。
既定では、Composerは私有リポジトリについてはgit-over-SSHのURLを生成し、公開リポジトリについてはHTTP(S)のみを生成します。

## forgejo-domains

既定では`["codeberg.org"]`です。
Forgejoサーバーのドメインのリストです。
`forgejo`リポジトリ種別を使う場合に使用されます。

## forgejo-token

ドメイン名とそのドメインで認証するためのユーザー名／アクセストークンのリストです。
たとえば、このオプションの値として`{"codeberg.org": {"username": "forgejo-user", "token":
"access-token"}}`を使うと、codeberg.orgに対して認証します。
なお、パッケージがcodeberg.orgのドメイン名でホストされていない場合、ドメイン名も[`forgejo-domains`](06-config.md#forgejo-domains)オプションで指定する必要があります。
詳細情報は[こちら](articles/authentication-for-private-packages.md#forgejo-token)にもあります。


## disable-tls

既定は`false`です。
真に設定すると、すべてのHTTPSのURLが代わりにHTTPで試行され、ネットワークレベルの暗号化は実行されません。
これを有効にすることはセキュリティ上の危険性であり、全く推奨されません。
より良い方法は、php.iniでphp_openssl拡張機能を有効にすることです。
これを有効にすると、`secure-http`オプションが暗黙に無効になります。

## secure-http

既定では`true`です。
真に設定すると、HTTPSのURLのみがComposer経由でダウンロードできるようになります。
何かしらへのHTTPアクセスが絶対に必要な場合は無効にできますが、[Let's
Encrypt](https://letsencrypt.org/)を使用して無料のSSL証明書を取得する方が一般的にはより良い代替手段です。

## bitbucket-oauth

ドメイン名と消費者のリストです。
例えば`{"bitbucket.org": {"consumer-key": "myKey", "consumer-secret":
"mySecret"}}`のように使います。
より詳しくは[こちら](articles/authentication-for-private-packages.md#bitbucket-oauth)を読んでください。

## cafile

ローカルファイルシステム上の認証局ファイルの配置場所です。
PHP 5.6以降ではシステムCAファイルを自動的に検出できますが、PHP
5.6以降でも、php.iniのopenssl.cafileを介してこれを設定すべきです。

## capath

cafileが指定されていない場合、またはそこに証明書がない場合は、capathが指すディレクトリで適切な証明書が探索されます。
capathは正しくハッシュされた証明書ディレクトリでなければなりません。

## http-basic

認証するためのドメイン名と、利用者名とパスワードのリストです。
たとえば、このオプションの値として`{"example.org": {"username": "alice", "password":
"foo"}}`を使用すると、Composerはexample.orgに対して認証します。
詳細については、[こちら](articles/authentication-for-private-packages.md#http-basic)を参照してください。

## bearer

認証するドメイン名とトークンのリストです。
たとえば、このオプションの値として`{"example.org": "foo"}`を使用すると、Composerは`Authorization:
Bearer foo`ヘッダーを使用して、example.orgに対して認証を行うことができます。

## platform

プラットフォームパッケージ（PHP及び拡張機能）を偽装して、運用環境をエミュレートしたり、構成で対象のプラットフォームを定義したりできるようにします。
例えば`{"php": "7.0.3", "ext-something": "4.0.3"}`です。

これにより、ローカルで実行する実際のPHPバージョンに関係なく、PHP 7.0.3以上を必要とするパッケージをインストールできなくなります。
ただし、依存関係が正しく検査されなくなったことも意味します。
PHP 5.6を実行すると、7.0.3を想定しているため問題なくインストールされますが、実行時に失敗します。
これは、`{"php":"7.4"}`が指定されることも意味します。
`7.4.1`を最小のバージョンとして定義するパッケージは使用されません。

したがって、これを使用する場合は、デプロイ戦略の一部として[`check-platform-reqs`](03-cli.md#check-platform-reqs)コマンドも走らせることをお勧めしますし、より安全です。

ローカルにインストールしていない拡張機能が依存関係に必要な場合は、代わりに`--ignore-platform-req=ext-foo`を`update`、`install`、または`require`に渡して無視できます。
しかし長い目で見れば、今は無視するにせよ必要な拡張はインストールすべきで、1箇月後に新しいパッケージでも必要になると、知らず知らずのうちに本番環境に問題が発生する可能性があります。

拡張をローカルにインストールしているが本番環境では*そうではない*場合、`{"ext-foo":
false}`を使ってComposerから意図的に隠すこともできます。

## vendor-dir

既定は`vendor`です。
お好みで違うディレクトリに依存関係をインストールできます。
vendor-dirと以下の全ての`*-dir`オプション中では、`$HOME`と`~`はホームディレクトリに置換されます。

## bin-dir

既定では`vendor/bin`です。
プロジェクトがバイナリを含む場合、それらのバイナリはこのディレクトリにシンボリックリンクが張られます。

## data-dir

既定では、Windowsでは`C:\Users\<user>\AppData\Roaming\Composer`、XDG Base Directory Specificationsに従うunixシステムでは`$XDG_DATA_HOME/composer`、その他のunixシステムでは`$COMPOSER_HOME`です。
現在、過去のcomposer.pharファイルを保存して古いバージョンにロールバックできるようにするためにのみ使用されています。
[COMPOSER_HOME](03-cli.md#composer-home)も参照してください。

Because `self-update --rollback` restores a previously stored
`composer.phar` from this directory, it must be writable only by the user
that owns the Composer installation and should be treated as a trusted
location. A directory writable by other users would let them plant a
malicious phar that a privileged rollback would install.

## cache-dir

既定では、Windowsでは`C:\Users\<user>\AppData\Local\Composer`、macOSでは`/Users/<user>/Library/Caches/composer`、XDG Base Directory Specificationに従うunixシステムでは`$XDG_CACHE_HOME/composer`、他のunixシステムでは`$COMPOSER_HOME/cache`になります。
Composerで使う全てのキャッシュが保管されます。
[COMPOSER_HOME](03-cli.md#composer-home)も参照してください。

## cache-files-dir

既定では`$cache-dir/files`です。
パッケージのzipアーカイブを保管します。

## cache-repo-dir

既定では`$cache-dir/repo`です。
`composer`の種別用のリポジトリのメタデータと、`svn`、`fossil`、`github`、`gitbucket`の種別のVCSリポジトリを保管します。

## cache-vcs-dir

既定では`$cache-dir/vcs`です。
`git`及び`hg`の種別用のVCSリポジトリメタデータを読み込むためのVCSクローンを保管し、インストールを高速にします。

## cache-files-ttl

既定では`15552000`（6箇月）です。
Composerはダウンロードした全てのdist（zip、tar、……）をキャッシュします。
既定では使われていないものについて6箇月経った後に削除します。
このオプションはこの期間を（秒数で）調整ないし0に設定することで、完全に無効にできるようにするものです。

## cache-files-maxsize

既定では`300MiB`です。
Composerはダウンロードした全ての配布パッケージ（zip、tar、……）をキャッシュします。
ガベージコレクションが定期的に走っている場合、キャッシュで使える最大量です。
最後のキャッシュヒットから時間が経った（比較的使われていない）ファイルが削除されます。

## cache-read-only

既定では`false`です。
Composerのキャッシュを読取専用モードで使うかどうかを決めます。

## bin-compat

既定では`auto`です。
インストールするバイナリの互換性を決定します。
`auto`の場合、Composerは、WindowsまたはWSLの場合に.batプロキシファイルのみをインストールします。
`full`に設定すると、Windows用の.batファイルとUnixベースのオペレーティングシステム用のスクリプトの両方がバイナリごとにインストールされます。
主にLinux VM内でComposerを実行しているが、WindowsホストOSで使用できる`.bat`プロキシが必要な場合に役立ちます。
`proxy`に設定すると、ComposerはbashでUnixスタイルのプロキシファイルのみを作成し、WindowsないしWSLでも.batファイルを作成しません。

## prepend-autoloader

既定は`true`です。
`false`にするとComposerの自動読み込み器は既存の自動読み込み器の前に置かれなくなります。
他の自動読み込み器との相互運用性の問題を修正する際に必要になることがあります。

## autoloader-suffix

既定では`null`です。
空でない文字列に設定した場合、生成されたComposerの自動読み込み器の接尾辞に使われます。
`null`に設定された場合、可能であれば`composer.lock`ファイルの`content-hash`値が使われます。
そうでなければ、乱択された接尾辞が生成されます。

## optimize-autoloader

既定では`false`です。
`true`の場合、自動読み込み器を吐き出す際に常に最適化されます。

## sort-packages

既定では`false`です。
`true`の場合、新しいパッケージを追加したときに`composer.json`中の`require`コマンドでパッケージが名前順に整列された状態に保たれます。

## classmap-authoritative

既定では`false`です。
`true`にするとComposerの自動読み込み器はクラスマップからのクラスのみを読み込みます。
暗に`optimize-autoloader`を有効にします。

## apcu-autoloader

既定では`false`です。
`true`の場合、Composerの自動読み込み器はAPCuを確認し、拡張が有効になった場合にクラスの有無をキャッシュするのに使います。

## github-domains

既定では`["github.com"]`です。
githubモードで使われるドメインのリストです。
GitHub Enterpriseの準備で使われます。

## github-expose-hostname

既定では`true`です。
`false`にするとgithub APIにアクセスするために作られるOAuthトークンがマシンのホスト名ではなく日付になります。

## use-github-api

既定では`true`です。
特定のリポジトリに於ける`no-api`キーに似ており、`use-github-api`を`false`に設定すると、他のgitリポジトリのように、全てのGitHubリポジトリについて、GitHub
APIを使う代わりにリポジトリをクローンするように大域的な挙動を定義します。
しかし`git`ドライバを直接使うのではなく、ComposerはやはりGitHubのzipファイルを使うことを試みます。

## notify-on-install

既定では`true`です。
Composerではリポジトリが通知のURLを定義できるようにしており、そのリポジトリからパッケージがインストールされたことの通知を受けられます。
このオプションはその挙動を無効にできます。

## discard-changes

既定では`false`で、`true`、`false`、または`stash`の何れかにできます。
このオプションでは非対話モードでダーティアップデートを制御する既定の方式を設定できます。
`true`はベンダーの変更を常に破棄しますが、`"stash"`は取っておいて再適用しようとします。
よくベンダーを変更する場合は、CIサーバーやデプロイスクリプトにこれを使ってください。

## archive-format

既定では`tar`です。
archiveコマンドにより使われる既定の形式を上書きします。

## archive-dir

既定では`.`です。
archiveコマンドによる作られる、アーカイブの既定の対象パスです。

例：

```json
{
    "config": {
        "archive-dir": "/home/user/.composer/repo"
    }
}
```

## htaccess-protect

既定では`true`です。
`false`に設定すると、ComposerはComposerのホーム、キャッシュ、データディレクトリに`.htaccess`ファイルを作りません。

## lock

既定では`true`です。
`false`に設定すると、Composerは`composer.lock`ファイルを作らず、存在している場合は無視します。

## platform-check

既定では、PHPのバージョンのみをチェックする`php-only`に設定されています。
拡張子の存在も確認するには、`true`に設定します。
`false`に設定すると、Composerは自動読み込み器のブートストラップの一部として`platform_check.php`ファイルを作成せず、requireもしません。

## secure-svn-domains

既定では`[]`です。
安全なSubversionまたはSVNの移送を使用しているものとして信頼し、印を付けるべきドメインの一覧です。
既定では、svn://プロトコルは安全ではないと見なされ、throwされますが、この構成オプションを`["example.org"]`に設定すれば、そのホスト名でsvnのURLを使用できます。
`secure-http`を完全に無効にするよりも優れた安全な代替手段です。

## bump-after-update

既定は`false`で、`true`、`false`、`"dev"`、`"no-dev"`のどれかにできます。
真に設定すると、Composerは`update`コマンドを走らせた後に、`bump`コマンドを走らせます。
`"dev"`や`"no-dev"`に設定すると、対応する依存関係のみのバージョンが上がります。

## allow-missing-requirements

既定は`false`です。
要件から何か欠けているものがあるとき、`install`時にエラーを無視します。
状況としては、`composer.json`にある最新の変更点に対して、固定ファイルが最新でないときです。

## update-with-minimal-changes

既定で偽です。
真にすると、更新するとき、遷移的な依存関係に絶対に必須なものだけ変更します。
`COMPOSER_MINIMAL_CHANGES=1`環境変数で設定することもできます。

&larr; [リポジトリ](05-repositories.md)  | [実行時](07-runtime.md) &rarr;
