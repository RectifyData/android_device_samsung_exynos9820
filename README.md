# TWRP Device Tree for Samsung Galaxy S10+

This is an **unified device tree** for the Exynos 9820 Galaxy S10+ (`beyond2lte`) family. It uses a shared device configuration and exposes only the `beyond2lte` product target. The tree is not intended to support the other Exynos 9820/9825 devices (S10e, S10, S10 5G, or Note10 series).

## Supported device

| Branding Name | Model Number | Codename |
| :--- | :--- | :--- |
| Samsung Galaxy S10+ (Exynos) | SM-G975F / SM-G975N | beyond2lte / beyond2lteks |

## Unified tree layout

- `twrp_beyond2lte.mk` defines the sole product.
- `beyond2lte/` contains the device-specific configuration.
- Root-level files contain configuration shared by the product.

## Kernel source

Available at [ExtremeXT/M62-backport](https://github.com/ExtremeXT/M62-backport).

> The kernel must be compiled with the `--recovery` flag set to `y`.

## Known issues

- `/data` decryption

## Build

This tree was tested with [minimal-manifest-twrp](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp).

1. Set up the build environment using the [TWRP getting-started instructions](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp/blob/twrp-12.1/README.md#getting-started).
2. Clone this branch into the device tree path:

   ```bash
   git clone https://github.com/RectifyData/android_device_samsung_exynos9820.git -b beyond2lte-only device/samsung/exynos9820
   ```

3. Build the recovery image:

   ```bash
   . build/envsetup.sh
   lunch twrp_beyond2lte-eng
   mka recoveryimage
   ```

## Copyright

```text
# Copyright (C) 2024 The TWRP Open Source Project
# SPDX-License-Identifier: Apache-2.0
```
