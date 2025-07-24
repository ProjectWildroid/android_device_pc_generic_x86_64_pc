#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/pc/generic_x86_64_pc

# Inherit from mainline/common
TARGET_AUDIO_HAL := tinyhal
TARGET_AUDIO_POLICY := custom
TARGET_CAMERA_PROVIDER_HAL := external
TARGET_GRAPHICS_ALLOCATOR_HAL := custom
TARGET_GRAPHICS_COMPOSER_HAL := custom
TARGET_HAS_VIBRATOR := false
TARGET_MESA_DO_NOT_SET_AS_DEFAULT := true
TARGET_SUPPORTS_SUSPEND := false
TARGET_SUPPORTS_USB_ACCESSORY_MODE := false
include device/mainline/common/optional/options.mk
$(call inherit-product, device/mainline/common/mainline_common.mk)

# Inherit from Wildroid
WILDROID_DEVICE_ARCH := x86_64
$(call inherit-product, vendor/wildroid/config/tablet.mk)

# Audio
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.xml,$(DEVICE_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc/) \
    device/google/cuttlefish/shared/config/audio/policy/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_with_le_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_with_le_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml

# Bootanimation
TARGET_SCREEN_WIDTH := 300
TARGET_SCREEN_HEIGHT := 300

# Dalvik heap
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# Firmware
PRODUCT_PACKAGES += \
    wireless-regdb_regulatory.db \
    wireless-regdb_regulatory.db.p7s

# Graphics
PRODUCT_PACKAGES += \
    gpu_detect

# Graphics allocator
PRODUCT_PACKAGES += \
    org.wildroid.device.graphics.allocator.minigbm \
    org.wildroid.device.graphics.allocator.minigbm_apex \
    org.wildroid.device.graphics.allocator.v2_0

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-service.minigbm_generic_x86 \
    gralloc.gbm \
    gralloc.minigbm_generic_x86 \
    mapper.minigbm_generic_x86

$(call soong_config_set_bool,minigbm,include_vintf_fragments,false)

# Graphics composer
PRODUCT_PACKAGES += \
    org.wildroid.device.graphics.composer.drm \
    org.wildroid.device.graphics.composer.drm.rc \
    org.wildroid.device.graphics.composer.drm_apex \
    org.wildroid.device.graphics.composer.v2_2 \
    org.wildroid.device.graphics.composer.v2_4

PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.2-service \
    android.hardware.graphics.composer@2.4-service

PRODUCT_PACKAGES += \
    android.hardware.composer.hwc3-service.drm \
    hwcomposer.drm

$(call soong_config_set_bool,drm_hwcomposer,include_init_rc,false)
$(call soong_config_set_bool,drm_hwcomposer,include_vintf_fragments,false)

# Graphics Vulkan
PRODUCT_PACKAGES += \
    org.wildroid.device.graphics.vulkan.no_apex \
    org.wildroid.device.graphics.vulkan.swiftshader

## TODO(b/65201432): Swiftshader needs to create executable memory.
PRODUCT_REQUIRES_INSECURE_EXECMEM_FOR_SWIFTSHADER := true

# HIDL
PRODUCT_PACKAGES += \
    vndservicemanager

# Init
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,fstab.*,$(DEVICE_PATH)/configs/fstab/,$(TARGET_COPY_OUT_VENDOR)/etc/) \
    $(call find-copy-subdir-files,init.*.rc,$(DEVICE_PATH)/configs/init/,$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/) \
    $(DEVICE_PATH)/configs/init/ueventd.rc:$(TARGET_COPY_OUT_ODM)/etc/ueventd.rc

# Input
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.kl,$(DEVICE_PATH)/configs/input/,$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/)

# Images
PRODUCT_BUILD_BOOT_IMAGE := false
PRODUCT_BUILD_RAMDISK_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# Kernel
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Mountpoints
PRODUCT_PACKAGES += \
    vendor_firmware_mountpoint

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlays/overlay

PRODUCT_PACKAGES += \
    AodDefaultOnOverlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/pc_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/pc_core_hardware.xml

# Ramdisk
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,fstab.*,$(DEVICE_PATH)/configs/fstab/,$(TARGET_COPY_OUT_RAMDISK)/)

# Scripts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/scripts/,$(TARGET_COPY_OUT_VENDOR)/bin/) \

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 33

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Utilities
PRODUCT_COPY_FILES += \
    vendor/wildroid/prebuilt/pci.ids:$(TARGET_COPY_OUT_VENDOR)/pci.ids \
    vendor/wildroid/prebuilt/usb.ids:$(TARGET_COPY_OUT_VENDOR)/usb.ids

# Wi-Fi
PRODUCT_COPY_FILES += \
    external/wpa_supplicant_8/wpa_supplicant/wpa_supplicant_template.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf
