<?php
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 WebTigers. Tiger™ and WebTigers™ are trademarks of WebTigers.
/**
 * Tiger AWS PHP SDK — provider-module bootstrap.
 *
 * A "provider" module: it ships no controllers, routes, or views — its whole job is to put the
 * vendored AWS SDK for PHP on the autoload path so `Aws\*` classes (e.g. `Aws\S3\S3Client`, used by
 * the core `Tiger_Media_Storage_S3` adapter) resolve. The SDK + all its dependencies (Guzzle, etc.)
 * live in this module's own `vendor/` (bundled into the release, not the repo).
 *
 * Active-only, by construction: a DEACTIVATED module's Bootstrap never runs (the modules resource
 * strips inactive slugs from the controller-directory map before bootstrapping), so the SDK is on
 * the path ONLY while this module is active. That is also why only ONE cloud-SDK provider may be
 * active at a time — see `module.json` "conflict" — two would load two copies of Guzzle and fatal.
 */
class TigerSdkAws_Bootstrap extends Zend_Application_Module_Bootstrap
{
    /** Register the bundled AWS SDK autoloader (no-op if the vendored bundle isn't present). */
    protected function _initSdkAutoload()
    {
        $autoload = __DIR__ . '/vendor/autoload.php';
        if (is_file($autoload)) {
            require_once $autoload;
        }
    }
}
