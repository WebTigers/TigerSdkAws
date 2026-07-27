# NOTICE

**Tiger AWS PHP SDK** (`webtigers/tiger-sdk-aws`) is licensed MIT — see [LICENSE](LICENSE). "Tiger"
and "WebTigers" are trademarks of WebTigers.

This module is a **repackaging convenience**: its released bundle vendors third-party software so a
Tiger install can use Amazon S3 storage without running Composer. That bundled software keeps its own
license, which governs its use:

| Bundled component | License | Home |
|---|---|---|
| `aws/aws-sdk-php` (AWS SDK for PHP) | Apache-2.0 | https://github.com/aws/aws-sdk-php |
| `guzzlehttp/guzzle`, `guzzlehttp/psr7`, `guzzlehttp/promises` | MIT | https://github.com/guzzle |
| `aws/aws-crt-php` | Apache-2.0 | https://github.com/awslabs/aws-crt-php |
| `mtdowling/jmespath.php` | MIT | https://github.com/jmespath/jmespath.php |
| `psr/http-message`, `psr/http-client`, `psr/http-factory` | MIT | https://github.com/php-fig |
| `symfony/polyfill-*` | MIT | https://github.com/symfony/polyfill |

The complete, authoritative license and copyright texts for every bundled package ship inside the
release bundle under `vendor/<vendor>/<package>/LICENSE` and are unmodified. No bundled source is
altered; this module only vendors and autoloads it. Refer to each package's own repository for its
canonical terms.
