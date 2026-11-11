# TWRP Device Tree for Samsung Galaxy S10+ (beyond2lte)

**Status: work in progress.** Not yet built or flashed on a device.

Unified Exynos 9820 device tree. It exposes one product, `twrp_beyond2lte`, for the Galaxy S10+ (SM-G975F / SM-G975N, codename `beyond2lte`).

## Layout

- `twrp_beyond2lte.mk` defines the product. `AndroidProducts.mk` lists it.
- `device.mk` and `BoardConfig.mk` hold the shared configuration.
- `beyond2lte/` holds device-specific files: prebuilt kernel and dtbo, and the recovery init rc.
- `recovery/root/` holds files copied into the recovery image, including `retrofit_precheck.sh`.
- `recovery.fstab` lists the partitions recovery mounts.

## Partition layout

The layout follows the LineageOS Exynos 9820 tree. Dynamic partitions are on, and super is carved from the physical `system` partition.

- Super size: 5976883200 bytes (the stock SYSTEM size in `BEYOND2LTE_EUR_OPEN.pit`).
- Group `samsung_dynamic_partitions`: system, vendor, product, odm. Group size: 5972688896 bytes.
- Metadata device: `system`.
- BOOT: 57671680 bytes. RECOVERY: 67633152 bytes. Block size: 4096 bytes.

`recovery/root/system/bin/retrofit_precheck.sh` is a read-only check. It reads the GPT and exits with an error if the system partition size does not match the build. Run it before any flash.

## Known issues

- The install-time writer for super metadata is not in this tree. LineageOS does this with `exynos9820.retrofit_dynamic_partitions`, which TWRP lacks. Without it, super has no metadata and logical partitions will not mount.
- AVB for dynamic partitions is not configured yet.
- Whether the device has a `@metadata` partition is unconfirmed. LineageOS's fstab expects one, and the stock PIT does not list one.
- Busybox is pulled from the manifest, not this tree.
- `/data` decryption is not working.

## Kernel source

Available at [ExtremeXT/M62-backport](https://github.com/ExtremeXT/M62-backport). Build the kernel with `--recovery` set to `y`.

## Build

This tree was set up with [minimal-manifest-twrp](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp).

1. Set up the build environment using the [TWRP getting-started instructions](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp/blob/twrp-12.1/README.md#getting-started).
2. Clone this branch into the device tree path. The product makefile expects this path, not `beyond2lte`:

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
