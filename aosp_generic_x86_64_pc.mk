#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

# Include EPPE fragment
include vendor/wildroid/config/fragments/eppe.mk

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Inherit from device
$(call inherit-product, device/pc/generic_x86_64_pc/device.mk)

PRODUCT_NAME := aosp_generic_x86_64_pc
PRODUCT_DEVICE := generic_x86_64_pc
PRODUCT_BRAND := PC
PRODUCT_MANUFACTURER := PC
PRODUCT_MODEL := Generic x86_64 PC
