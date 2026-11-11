#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 The TWRP Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a75

# Bootloader
TARGET_NO_BOOTLOADER := true

# Kernel
TARGET_KERNEL_ARCH := $(TARGET_ARCH)
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/$(PRODUCT_DEVICE)/prebuilt/$(BOARD_KERNEL_IMAGE_NAME)
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/$(PRODUCT_DEVICE)/prebuilt/dtbo.img

# RAMDisk Compression
LZMA_RAMDISK_TARGETS := recovery,boot
BOARD_RAMDISK_USE_LZMA := true

BOARD_MKBOOTIMG_ARGS := \
    --base 0x10000000 \
    --kernel_offset 0x00008000 \
    --pagesize 2048 \
    --ramdisk_offset 0x01000000 \
    --os_version 14.0.0 \
    --tags_offset 0x00000100 \
    --header_version 1

# Partitions
# BOOT is 14080 blocks of 4096 bytes in the stock BEYOND2LTE_EUR_OPEN.pit (57671680 bytes)
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_BOOTIMAGE_PARTITION_SIZE := 57671680
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_DTBIMG_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67633152

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_ROOT_EXTRA_FOLDERS := \
    efs \
    keydata \
    keyrefuge \
    omr

# Filesystem
BOARD_SYSTEM_PARTITION_LIST := system odm product vendor
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_SYSTEM_PARTITION_LIST))

$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Dynamic partitions, LineageOS layout. Super is carved from the physical system partition
# (stock SYSTEM = 1459200 blocks x 4096 bytes in BEYOND2LTE_EUR_OPEN.pit). Matches the
# LineageOS exynos9820-common tree. Metadata is written at install time from super_empty.img.
# retrofit_precheck.sh in recovery/root/system/bin checks the system size before flashing.
ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
BOARD_SUPER_PARTITION_SIZE := 5976883200
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product odm
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 5972688896
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
endif

# Android Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Encryption
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := ABGR_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
RECOVERY_SDCARD_ON_DATA := true

# Use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true

# TWRP specific build flags
TW_DEVICE_VERSION := Android-Artisan_v2-
TW_THEME := portrait_hdpi
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel/brightness"
TW_MAX_BRIGHTNESS := 25500
TW_DEFAULT_BRIGHTNESS := 12800
TW_NO_REBOOT_BOOTLOADER := true
TW_HAS_DOWNLOAD_MODE := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_BACKUP_EXCLUSIONS := /data/fonts/files
TW_EXTRA_LANGUAGES := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_ENABLE_FS_COMPRESSION := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
TW_INCLUDE_FASTBOOTD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
