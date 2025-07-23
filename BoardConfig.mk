#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

USES_DEVICE_PC_GENERIC_X86_64_PC := true

# Inherit from mainline/common
include device/mainline/common/BoardConfigMainlineCommon.mk

# A/B
AB_OTA_UPDATER := false

# Audio
$(call soong_config_set_bool,tinyhal,libaudiohalcm_continue_on_ctl_open_error,true)

# Architecture
TARGET_CPU_ABI := x86_64
TARGET_ARCH := x86_64
TARGET_ARCH_VARIANT := sandybridge

# Boot manager
TARGET_BOOT_MANAGER := grub
TARGET_GRUB_ARCH := x86_64-efi
TARGET_GRUB_2ND_ARCH := i386-pc
TARGET_GRUB_LIVE_CONFIGS := $(DEVICE_PATH)/configs/bootmgr/grub-live.cfg

# Boot parameters
BOARD_KERNEL_CMDLINE := \
    $(MAINLINE_COMMON_ANDROIDBOOT_PARAMS) \
    $(MAINLINE_COMMON_KERNEL_PARAMS) \
    androidboot.boot_devices=any \
    androidboot.fstab_suffix=bind_mount.image \
    androidboot.hardware=generic \
    androidboot.init_fatal_pause=true \
    androidboot.mount_on_oem_which_contain=android/system.img;android/vendor.img \
    androidboot.selinux=permissive \
    androidboot.verifiedbootstate=orange \
    audit=0 \
    console=tty0 \
    mitigations=off

BOARD_KERNEL_CMDLINE_LIVE := \
    androidboot.use_tmpfs_userdata=1

# Filesystem
BOARD_EROFS_SHARE_DUP_BLOCKS := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

# Graphics (Mesa)
BOARD_MESA3D_BUILD_LIBGBM := true
BOARD_MESA3D_GALLIUM_DRIVERS += \
    crocus \
    iris \
    radeonsi \
    r300 \
    r600 \
    svga \
    virgl
# Not supported yet: nouveau
BOARD_MESA3D_VULKAN_DRIVERS += \
    amd \
    intel \
    intel_hasvk \
    virtio
# Not supported yet: nouveau

# Graphics allocator (minigbm)
$(call soong_config_set, minigbm, platform, generic_x86)

# Kernel
BOARD_KERNEL_IMAGE_NAME := bzImage
MERGE_ALL_KERNEL_CONFIGS_AT_ONCE := true
TARGET_KERNEL_CONFIG := gki_defconfig
TARGET_KERNEL_CONFIG_EXT := \
    $(wildcard $(DEVICE_PATH)/kconfigs/*.config) \
    kernel/mainline/configs/fragments/n/faster-build-time.config
TARGET_KERNEL_SOURCE := kernel/pc/generic_x86_64_pc

# OTA
TARGET_SKIP_OTA_PACKAGE := true

# Partitions
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_USES_METADATA_PARTITION := true
TARGET_COPY_OUT_VENDOR := vendor

TARGET_PARTITION_IMAGES_FILE_SYSTEM_TYPE ?= erofs
ifeq ($(TARGET_PARTITION_IMAGES_FILE_SYSTEM_TYPE),ext4)
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_VENDORIMAGE_EXTFS_INODE_COUNT := -1
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 67108864
else ifeq ($(TARGET_PARTITION_IMAGES_FILE_SYSTEM_TYPE),erofs)
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
endif

# Platform
TARGET_BOARD_PLATFORM := generic

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/configs/properties/product.prop
TARGET_VENDOR_PROP += \
    $(DEVICE_PATH)/configs/properties/vendor.prop \
    $(DEVICE_PATH)/configs/properties/vendor_bluetooth_profiles.prop

# Ramdisk
BOARD_RAMDISK_USE_LZ4 := true

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy/vendor \
    $(MAINLINE_COMMON_PATH)/sepolicy/vendor/minigbm \
    external/minigbm/cros_gralloc/sepolicy

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public

# VINTF
DEVICE_MANIFEST_FILE := \
    $(DEVICE_PATH)/configs/vintf/manifest.xml

ODM_MANIFEST_SKUS := minigbm-generic-x86-imapper5
ODM_MANIFEST_MINIGBM-GENERIC-X86-IMAPPER5_FILES := external/minigbm/cros_gralloc/mapper_stablec/mapper.minigbm_generic_x86.xml
