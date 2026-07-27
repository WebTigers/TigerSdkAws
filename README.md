# Tiger AWS PHP SDK (`webtigers/tiger-sdk-aws`)

A **Tiger provider module** that vendors the [AWS SDK for PHP](https://github.com/aws/aws-sdk-php) so
a Tiger install can use **Amazon S3** media storage **without running Composer on the server** — the
shared-hosting / cPanel case.

It ships **no controllers, routes, or views**. Its only job is to register the bundled SDK's
autoloader (see [`Bootstrap.php`](Bootstrap.php)) so `Aws\S3\S3Client` — used by the core
`Tiger_Media_Storage_S3` adapter — resolves while the module is active.

## Install

Use the Tiger **Module Manager** (Add module → from URL), point it at this repo, and activate. Then
choose **Amazon S3** under *Settings → Media → Storage* and **Test connection**.

## One cloud SDK at a time

This module declares a `conflict` with the Google Cloud and Azure SDK providers in
[`module.json`](module.json). Activating one cloud SDK auto-deactivates the others (with a confirm),
because loading two would load two copies of Guzzle. Most installs use a single cloud backend.

## How the bundle is built

The repo does **not** commit `vendor/` — it's a **release artifact**. CI
([`.github/workflows/release.yml`](.github/workflows/release.yml)) runs
[`bin/build-bundle.sh`](bin/build-bundle.sh), which:

1. `composer update aws/aws-sdk-php ^3` to resolve the latest SDK + dependencies,
2. stamps `module.json`'s `version` to that exact SDK version,
3. zips the module (with the resolved `vendor/`) as `tiger-sdk-aws-<version>.zip`, and
4. cuts a GitHub release tagged with the SDK version — **one bundle per module, tracking upstream**.

So "the latest version" is simply the newest release; the Module Manager surfaces available versions
and flags updates.

## License

MIT (this module) — see [LICENSE](LICENSE). Bundled third-party licenses (AWS SDK: Apache-2.0; Guzzle
et al.: MIT) are catalogued in [NOTICE.md](NOTICE.md).
