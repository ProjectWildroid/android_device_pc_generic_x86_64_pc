#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/pc/generic_x86_64_pc

# Inherit from mainline/common
TARGET_HAS_VIBRATOR := false
TARGET_MESA_DO_NOT_SET_AS_DEFAULT := true
TARGET_SUPPORTS_SUSPEND := false
TARGET_SUPPORTS_USB_ACCESSORY_MODE := false
TARGET_USES_FRAMEBUFFER_DISPLAY := true
include device/mainline/common/optional/options.mk
$(call inherit-product, device/mainline/common/mainline_common.mk)

# Inherit from Wildroid
$(call inherit-product, vendor/wildroid/config/tablet.mk)

# Bootanimation
TARGET_SCREEN_WIDTH := 300
TARGET_SCREEN_HEIGHT := 300

# Dalvik heap
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# Graphics
PRODUCT_PACKAGES += \
    gpu_detect

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
    $(call find-copy-subdir-files,*.rc,$(DEVICE_PATH)/configs/init/,$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/)

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
