# Tiger AWS PHP SDK

Adds the **AWS SDK for PHP** to your Tiger install so you can store media in **Amazon S3** — with
**no Composer required on the server**. Install it from the Module Manager, activate it, then pick
**Amazon S3** in *Settings → Media → Storage*.

- **What it does:** bundles `aws/aws-sdk-php` and everything it needs (Guzzle, etc.), and puts it on
  the autoload path only while the module is active. The core S3 storage adapter
  (`Tiger_Media_Storage_S3`) does the rest.
- **One cloud SDK at a time.** This module is mutually exclusive with the Google Cloud and Azure SDK
  providers — activating one automatically deactivates the others (you'll be asked to confirm). Almost
  every install uses a single cloud backend, and keeping one active avoids loading two copies of the
  shared HTTP library.
- **Credentials:** on AWS/EC2 you can leave the access key and secret blank and use the server's IAM
  instance role — nothing sensitive is stored. Elsewhere, enter an access key + secret on the Storage
  tab.
- **Updates:** the bundle tracks the latest `aws/aws-sdk-php` release; the Module Manager tells you
  when a newer version is available.

**License:** MIT (this module). The bundled AWS SDK is Apache-2.0 and its HTTP dependencies are MIT —
see [NOTICE](NOTICE.md). "Tiger" and "WebTigers" are trademarks of WebTigers.
