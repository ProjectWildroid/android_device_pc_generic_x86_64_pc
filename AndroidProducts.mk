#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/aosp_generic_x86_64_pc.mk

WILDROID_MULTIPRODUCT_AOSP_PRODUCTMK := $(LOCAL_DIR)/aosp_generic_x86_64_pc.mk
WILDROID_MULTIPRODUCT_IS_GO := false
WILDROID_MULTIPRODUCT_IS_WIFIONLY := true
WILDROID_MULTIPRODUCT_NAME := generic_x86_64_pc
WILDROID_MULTIPRODUCT_SIZE := full
WILDROID_MULTIPRODUCT_TYPE := pc
include vendor/wildroid/multiproduct/AndroidProductsHelper.mk
