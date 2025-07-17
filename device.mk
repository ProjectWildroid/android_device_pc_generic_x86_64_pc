#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/pc/generic_x86_64_pc

# Inherit from mainline/common
TARGET_HAS_BATTERY := false
TARGET_HAS_VIBRATOR := false
TARGET_SUPPORTS_SUSPEND := false
TARGET_SUPPORTS_USB_ACCESSORY_MODE := false
TARGET_USES_FRAMEBUFFER_DISPLAY := true
include device/mainline/common/optional/options.mk
$(call inherit-product, device/mainline/common/mainline_common.mk)

# Bootanimation
TARGET_SCREEN_WIDTH := 300
TARGET_SCREEN_HEIGHT := 300

# Dalvik heap
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# HIDL
PRODUCT_PACKAGES += \
    vndservicemanager

# Init
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/fstab/fstab.generic:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.generic \
    $(DEVICE_PATH)/configs/init/init.generic.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.generic.rc

# Images
PRODUCT_BUILD_BOOT_IMAGE := false
PRODUCT_BUILD_RAMDISK_IMAGE := true
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# Kernel
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Mountpoints
PRODUCT_PACKAGES += \
    vendor_firmware_mountpoint

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlays/overlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/pc_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/pc_core_hardware.xml

# Ramdisk
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/fstab/fstab.generic:$(TARGET_COPY_OUT_RAMDISK)/fstab.generic

# Recovery
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/init/init.recovery.generic.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.generic.rc

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 33

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Utilities
PRODUCT_COPY_FILES += \
    vendor/wildroid/prebuilt/pci.ids:$(TARGET_COPY_OUT_VENDOR)/pci.ids \
    vendor/wildroid/prebuilt/usb.ids:$(TARGET_COPY_OUT_VENDOR)/usb.ids
