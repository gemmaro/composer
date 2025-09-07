<!--
    tagline: 問題解決
-->
# 困ったときは

以下はComposerを使う上でよくある罠とその回避方法です。


## 一般

1. Composerを使っていてどんな問題に直面したときも、必ず **最新版を使って** ください。
   詳しくは[self-update](../03-cli.md#self-update)をご参照ください。

2. 誰かに尋ねる前に、[`composer diagnose`](../03-cli.md#diagnose)を走らせてください。
   よくある問題を確認できます。
   全て確認したら、次の工程にお進みください。

3. `curl -sS https://getcomposer.org/installer | php --
   --check`としてインストーラの検査を実行し、セットアップに問題がないことを確かめてください。

4. `composer clear-cache`を走らせて、Composerのキャッシュを消去してみてください。

5. 困ったときは`rm -rf vendor && composer update -v`とし、必ず
   **`composer.json`から直にvendorをインストール** してください。
   ただし、既存のvendorのインストールや`composer.lock`の項目についての障害が考えられる場合は除きます。


## パッケージが見付かりません

1. `composer.json`やリポジトリのブランチやタグ名で **誤植をしていないか** よくご確認ください。

2. 必ず **正しい[minimum-stability](../04-schema.md#minimum-stability)を設定**
   してください。
   始めたてのときや、これが問題になっていないことを確かめるには、`minimum-stability`を「dev」に設定してください。

3. **[Packagist](https://packagist.org/)由来でない** パッケージはいつも（全てのベンダーに依存する）
   **根幹パッケージに定義** すべきです。

4. リポジトリの全てのブランチとタグについて **同じベンダーとパッケージ名** をお使いください。
   特にサードパーティーフォークを保守しており、`replace`を使っているときはそうです。

5. 最近公開されたバージョンのパッケージに更新しているときは、Packagistでは新しいパッケージがComposerで認識されるようになるまで1分まで遅延することがあります。

6. 1つのパッケージを更新している場合、その新しいバージョンに依存しているかもしれません。
   この場合、コマンドに`--with-dependencies`引数を加えるか、 **もしくは** 更新が必要な全ての依存関係を加えてください。


## パッケージが期待するバージョンに更新されない

`php composer.phar why-not パッケージ名 期待するバージョン`を実行してみてください。


## ルートパッケージへの依存関係

ルートパッケージが何らかのパッケージに依存しており、そのパッケージから（直接ないし間接に）そのルートパッケージ自体に依存関係が戻ってしまうとき、問題は2通りで起こり得ます。

1. 開発する際、`dev-main`のようなブランチにあり、ブランチに[ブランチ別称](aliases.md#branch-alias)が定義されておらず、ルートパッケージへの依存関係で例えばバージョン`^2.0`が必要であれば、`dev-main`バージョンは満たされません。
   ここでの一番の解決策は、まずブランチ別称を定義していることを確かめることです。

2. CI (Continuous Integration)
   が実行されるとき、問題はComposerがルートパッケージのバージョンを適切に検知できないことにあるかもしれません。
   もしGitクローンであれば、一般には大丈夫で、Composerにより現在のブランチのバージョンが検出されるでしょう。
   しかし、CIによってはシャロークローンをするため、プルリクエストや機能ブランチをテストするときにプロセスが失敗しかねません。
   そうした場合、ブランチ別称は認識されないかもしれません。
   一番の解決策は`COMPOSER_ROOT_VERSION`という環境変数で現在のバージョンを定義することです。
   例えば`dev-main`に設定するとルートパッケージのバージョンは`dev-main`で定義されます。
   使用例は`COMPOSER_ROOT_VERSION=dev-main composer
   install`で、composerの呼び出しでのみ変数をエクスポートしています。
   もしくはCIの環境変数に大域的に定義できます。

## 根幹パッケージのバージョン制約

Composer relies on knowing the version of the root package to resolve
dependencies effectively. The version of the root package is determined
using a hierarchical approach:

1. **composer.json Version Field**: Firstly, Composer looks for a `version`
   field in the project's root `composer.json` file. If present, this field
   specifies the version of the root package directly. This is generally not
   recommended as it needs to be constantly updated, but it is an option.

2. **Environment Variable**: Composer then checks for the
   `COMPOSER_ROOT_VERSION` environment variable. This variable can be
   explicitly set by the user to define the version of the root package,
   providing a straightforward way to inform Composer of the exact version,
   especially in CI/CD environments or when the VCS method is not
   applicable.

3. **Version Control System (VCS) Inspection**: Composer then attempts to
   guess the version by interfacing with the version control system of the
   project. For instance, in projects versioned with Git, Composer executes
   specific Git commands to deduce the project's current version based on
   tags, branches, and commit history. If a `.git` directory is missing or
   the history is incomplete because CI is using a shallow clone for
   example, this detection may fail to find the correct version.

4. **Fallback**: If all else fails, Composer uses `1.0.0` as default
   version.

Note that relying on the default/fallback version might potentially lead to
dependency resolution issues, especially when the root package depends on a
package which ends up depending (directly or indirectly)  [back on the root
package itself](#dependencies-on-the-root-package).

## Network timeout issues, curl error

If you see something along the lines of:

```
Failed to download * curl error 28 while downloading * Operation timed out after 300000 milliseconds
```

It means your network is probably so slow that a request took over
300seconds to complete. This is the minimum timeout Composer will use, but
you can increase it by increasing the `default_socket_timeout` value in your
php.ini to something higher.


## Package not found in a Jenkins-build

1. Check the ["Package not found"](#package-not-found) item above.

2. The git-clone / checkout within Jenkins leaves the branch in a "detached
   HEAD"-state. As a result, Composer may not able to identify the version
   of the current checked out branch and may not be able to resolve a
   [dependency on the root package](#dependencies-on-the-root-package).  To
   solve this problem, you can use the "Additional Behaviours" -> "Check out
   to specific local branch" in your Git-settings for your Jenkins-job,
   where your "local branch" shall be the same branch as you are checking
   out. Using this, the checkout will not be in detached state any more and
   the dependency on the root package should become satisfied.


## I have a dependency which contains a "repositories" definition in its composer.json, but it seems to be ignored.

The [`repositories`](../04-schema.md#repositories) configuration property is
defined as [root-only](../04-schema.md#root-package). It is not
inherited. You can read more about the reasons behind this in the "[why
can't Composer load repositories
recursively?](../faqs/why-cant-composer-load-repositories-recursively.md)"
article.  The simplest work-around to this limitation, is moving or
duplicating the `repositories` definition into your root composer.json.


## I have locked a dependency to a specific commit but get unexpected results.

While Composer supports locking dependencies to a specific commit using the
`#commit-ref` syntax, there are certain caveats that one should take into
account. The most important one is
[documented](../04-schema.md#package-links), but frequently overlooked:

> **Note:** While this is convenient at times, it should not be how you use
> packages in the long term because it comes with a technical limitation. The
> composer.json metadata will still be read from the branch name you specify
> before the hash. Because of that in some cases it will not be a practical
> workaround, and you should always try to switch to tagged releases as soon
> as you can.

There is no simple work-around to this limitation. It is therefore strongly
recommended that you do not use it.


## Need to override a package version

Let's say your project depends on package A, which in turn depends on a
specific version of package B (say 0.1). But you need a different version of
said package B (say 0.11).

You can fix this by aliasing version 0.11 to 0.1:

composer.json:

```json
{
    "require": {
        "A": "0.2",
        "B": "0.11 as 0.1"
    }
}
```

詳細は[別称](aliases.md)をご確認ください。


## 構成値がどこから来たものか調べる

`php composer.phar config --list --source`を使うと、それぞれの構成値の出自がわかります。

## Memory limit errors

The first thing to do is to make sure you are running Composer 2, and if
possible 2.2.0 or above.

Composer 1 used much more memory and upgrading to the latest version will
give you much better and faster results.

Composer may sometimes fail on some commands with this message:

`PHP Fatal error:  Allowed memory size of XXXXXX bytes exhausted <...>`

In this case, the PHP `memory_limit` should be increased.

> **Note:** Composer internally increases the `memory_limit` to `1.5G`.

To get the current `memory_limit` value, run:

```shell
php -r "echo ini_get('memory_limit').PHP_EOL;"
```

Try increasing the limit in your `php.ini` file (ex. `/etc/php5/cli/php.ini`
for Debian-like systems):

```ini
; Use -1 for unlimited or define an explicit value like 2G
memory_limit = -1
```

Composer also respects a memory limit defined by the `COMPOSER_MEMORY_LIMIT`
environment variable:

```shell
COMPOSER_MEMORY_LIMIT=-1 composer.phar <...>
```

Or, you can increase the limit with a command-line argument:

```shell
php -d memory_limit=-1 composer.phar <...>
```

However, please note that setting the memory limit using these methods
primarily addresses memory issues within Composer itself and its immediate
processes. Child processes or external commands invoked by Composer may
still require separate adjustments if they have their own memory
requirements.

This issue can also happen on cPanel instances, when the shell fork bomb
protection is activated. For more information, see the
[documentation](https://documentation.cpanel.net/display/68Docs/Shell+Fork+Bomb+Protection)
of the fork bomb feature on the cPanel site.

## Xdebug impact on Composer

To improve performance when the Xdebug extension is enabled, Composer
automatically restarts PHP without it.  You can override this behavior by
using an environment variable: `COMPOSER_ALLOW_XDEBUG=1`.

Composer will always show a warning if Xdebug is being used, but you can
override this with an environment variable:
`COMPOSER_DISABLE_XDEBUG_WARN=1`. If you see this warning unexpectedly, then
the restart process has failed: please report this
[issue](https://github.com/composer/composer/issues).


## "The system cannot find the path specified" (Windows)

1. Open regedit.
2. Search for an `AutoRun` key inside
   `HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor`,
   `HKEY_CURRENT_USER\Software\Microsoft\Command Processor` or
   `HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Command Processor`.
3. Check if it contains any path to a non-existent file, if it's the case,
   remove them.


## SSL certificate problem: unable to get local issuer certificate

1. Check that your root certificate store / CA bundle is up to date. Run
   `composer diagnose -vvv` and look for `Checked CA file ...` or `Checked
   directory ...` lines in the first lines of output.  This will show you
   where Composer is looking for a CA bundle. You can get a [new cacert.pem
   from cURL](https://curl.se/docs/caextract.html) and store it there.
2. If this did not help despite Composer finding a valid CA bundle, try
   disabling your antivirus and firewall software to see if that helps. We
   have seen issues where Avast on Windows for example would prevent
   Composer from functioning correctly. To disable the HTTPS scanning in
   Avast you can go in "Protection > Core Shields > Web Shield > **uncheck**
   Enable HTTPS scanning". If this helps you should report it to the
   software vendor so they can hopefully improve things.


## API rate limit and OAuth tokens

Because of GitHub's rate limits on their API it can happen that Composer
prompts for authentication asking your username and password so it can go
ahead with its work.

If you would prefer not to provide your GitHub credentials to Composer you
can manually create a token using the [procedure documented
here](authentication-for-private-packages.md#github-oauth).

Now Composer should install/update without asking for authentication.


## proc_open(): fork failed errors

If Composer shows proc_open() fork failed on some commands:

`PHP Fatal error: Uncaught exception 'ErrorException' with message
'proc_open(): fork failed - Cannot allocate memory' in phar`

This could be happening because the VPS runs out of memory and has no Swap
space enabled.

```shell
free -m
```
```text
total used free shared buffers cached
Mem: 2048 357 1690 0 0 237
-/+ buffers/cache: 119 1928
Swap: 0 0 0
```

To enable the swap you can use for example:

```shell
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/bin/chmod 0600 /var/swap.1
/sbin/swapon /var/swap.1
```
You can make a permanent swap file following this
[tutorial](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04).


## proc_open(): failed to open stream errors (Windows)

If Composer shows proc_open(NUL) errors on Windows:

`proc_open(NUL): failed to open stream: No such file or directory`

This could be happening because you are working in a _OneDrive_ directory
and using a version of PHP that does not support the file system semantics
of this service. The issue was fixed in PHP 7.2.23 and 7.3.10.

Alternatively it could be because the Windows Null Service is not
enabled. For more information, see this
[issue](https://github.com/composer/composer/issues/7186#issuecomment-373134916).


## Degraded Mode

Due to some intermittent issues on Travis and other systems, we introduced a
degraded network mode which helps Composer finish successfully but disables
a few optimizations. This is enabled automatically when an issue is first
detected. If you see this issue sporadically you probably don't have to
worry (a slow or overloaded network can also cause those time outs), but if
it appears repeatedly you might want to look at the options below to
identify and resolve it.

If you have been pointed to this page, you want to check a few things:

- If you are using ESET antivirus, go in "Advanced Settings" and disable
  "HTTP-scanner" under "web access protection"
- If you are using IPv6, try disabling it. If that solves your issues, get
  in touch with your ISP or server host, the problem is not at the Packagist
  level but in the routing rules between you and Packagist (i.e. the
  internet at large). The best way to get these fixed is to raise awareness
  to the network engineers that have the power to fix it.  Take a look at
  the next section for IPv6 workarounds.
- If none of the above helped, please report the error.


## Operation timed out (IPv6 issues)

You may run into errors if IPv6 is not configured correctly. A common error
is:

```text
The "https://getcomposer.org/version" file could not be downloaded: failed to
open stream: Operation timed out
```

We recommend you fix your IPv6 setup. If that is not possible, you can try
the following workarounds:

**Generic Workaround:**

[`COMPOSER_IPRESOLVE=4`](../03-cli.md#composer-ipresolve)環境変数を設定すると、curlをIPv4を使ってドメイン解決するよう強制します。
これはcurl拡張がダウンロード用に使われるときだけ機能します。

**Workaround Linux:**

On linux, it seems that running this command helps to make ipv4 traffic have
a higher priority than ipv6, which is a better alternative than disabling
ipv6 entirely:

```shell
sudo sh -c "echo 'precedence ::ffff:0:0/96 100' >> /etc/gai.conf"
```

**Workaround Windows:**

On windows the only way is to disable ipv6 entirely I am afraid (either in
windows or in your home router).

**Workaround Mac OS X:**

Get name of your network device:

```shell
networksetup -listallnetworkservices
```

Disable IPv6 on that device (in this case "Wi-Fi"):

```shell
networksetup -setv6off Wi-Fi
```

Composerを実行……

You can enable IPv6 again with:

```shell
networksetup -setv6automatic Wi-Fi
```

That said, if this fixes your problem, please talk to your ISP about it to
try to resolve the routing errors. That's the best way to get things
resolved for everyone.


## Composer hangs with SSH ControlMaster

When you try to install packages from a Git repository and you use the
`ControlMaster` setting for your SSH connection, Composer might hang
endlessly and you see a `sh` process in the `defunct` state in your process
list.

The reason for this is a SSH Bug:
https://bugzilla.mindrot.org/show_bug.cgi?id=1988

As a workaround, open a SSH connection to your Git host before running
Composer:

```shell
ssh -t git@mygitserver.tld
php composer.phar update
```

詳しくは https://github.com/composer/composer/issues/4180 も参照。


## Zip archives are not unpacked correctly.

Composer can unpack zipballs using either a system-provided `unzip` or `7z`
(7-Zip) utility, or PHP's native `ZipArchive` class. On OSes where ZIP files
can contain permissions and symlinks, we recommend installing `unzip` or
`7z` as these features are not supported by `ZipArchive`.


## Disabling the pool optimizer

In Composer, the `Pool` class contains all the packages that are relevant
for the dependency resolving process. That is what is used to generate all
the rules which are then passed on to the dependency solver.  In order to
improve performance, Composer tries to optimize this `Pool` by removing
useless package information early on.

If all goes well, you should never notice any issues with it but in case you
run into an unexpected result such as an unresolvable set of dependencies or
conflicts where you think Composer is wrong, you might want to disable the
optimizer by using the environment variable `COMPOSER_POOL_OPTIMIZER` and
run the update again like so:

```shell
COMPOSER_POOL_OPTIMIZER=0 php composer.phar update
```

Now double check if the result is still the same. It will take significantly
longer and use a lot more memory to run the dependency resolving process.

If the result is different, you likely hit a problem in the pool optimizer.
Please [report this issue](https://github.com/composer/composer/issues) so
it can be fixed.
