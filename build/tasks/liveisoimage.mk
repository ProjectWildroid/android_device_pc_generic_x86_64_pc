#
# SPDX-FileCopyrightText: The Wildroid Project
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(USES_DEVICE_PC_GENERIC_X86_64_PC),true)

BOOTMGR_TOOLS_BIN_DIR := prebuilts/bootmgr/tools/$(HOST_PREBUILT_TAG)/bin
BOOTMGR_PATH_OVERRIDE := PATH=$(BOOTMGR_TOOLS_BIN_DIR):$$PATH
BOOTMGR_XORRISO_EXEC := $(BOOTMGR_TOOLS_BIN_DIR)/xorriso

ifneq ($(LINEAGE_BUILD),)
BOOTMGR_ANDROID_DISTRIBUTION_NAME := LineageOS $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)
BOOTMGR_ARTIFACT_FILENAME_PREFIX := lineage-$(LINEAGE_VERSION)
else
LOCAL_BUILD_DATE := $(shell date -u +%Y%m%d)
BOOTMGR_ANDROID_DISTRIBUTION_NAME ?= Android $(PLATFORM_VERSION_LAST_STABLE) $(BUILD_ID)
BOOTMGR_ARTIFACT_FILENAME_PREFIX ?= Android-$(PLATFORM_VERSION_LAST_STABLE)-$(BUILD_ID)-$(LOCAL_BUILD_DATE)-$(TARGET_PRODUCT)
endif

# $(1): path to boot manager config file
define process-bootmgr-cfg-common
	sed -i "s|@BOOTMGR_ANDROID_DISTRIBUTION_NAME@|$(BOOTMGR_ANDROID_DISTRIBUTION_NAME)|g" $(1)
	sed -i "s|@STRIPPED_BOARD_KERNEL_CMDLINE@|$(subst ;,\\\;,$(strip $(BOARD_KERNEL_CMDLINE)))|g" $(1)
endef
define process-bootmgr-cfg-live
	sed -i "s|@STRIPPED_BOARD_KERNEL_CMDLINE_LIVE@|$(subst ;,\\\;,$(strip $(BOARD_KERNEL_CMDLINE_LIVE)))|g" $(1)
endef

INSTALLED_LIVEISOIMAGE_TARGET := $(PRODUCT_OUT)/$(BOOTMGR_ARTIFACT_FILENAME_PREFIX)-live.iso

INSTALLED_LIVEISOIMAGE_TARGET_INCLUDE_FILES := \
    $(PRODUCT_OUT)/kernel \
    $(PRODUCT_OUT)/ramdisk.img \
    $(PRODUCT_OUT)/system.img \
    $(PRODUCT_OUT)/vendor.img

INSTALLED_LIVEISOIMAGE_TARGET_DEPS := \
	$(INSTALLED_LIVEISOIMAGE_TARGET_INCLUDE_FILES)

ifeq ($(TARGET_BOOT_MANAGER),grub)
ifneq ($(TARGET_GRUB_ARCH),)

INSTALLED_LIVEISOIMAGE_TARGET_DEPS += \
	$(TARGET_GRUB_LIVE_CONFIGS)

TARGET_GRUB_HOST_PREBUILT_TAG ?= $(HOST_PREBUILT_TAG)
TARGET_GRUB_2ND_ARCH_HOST_PREBUILT_TAG ?= $(HOST_PREBUILT_TAG)
GRUB_PREBUILT_DIR := prebuilts/bootmgr/grub/$(TARGET_GRUB_HOST_PREBUILT_TAG)/$(TARGET_GRUB_ARCH)
GRUB_2ND_ARCH_PREBUILT_DIR := prebuilts/bootmgr/grub/$(TARGET_GRUB_2ND_ARCH_HOST_PREBUILT_TAG)/$(TARGET_GRUB_2ND_ARCH)

GRUB_WORKDIR_BASE := $(TARGET_OUT_INTERMEDIATES)/GRUB_OBJ
GRUB_WORKDIR_LIVE := $(GRUB_WORKDIR_BASE)/live

# $(1): output file
define make-liveisoimage-target
	rm -rf $(GRUB_WORKDIR_LIVE)
	mkdir -p $(GRUB_WORKDIR_LIVE)/fsroot/android $(GRUB_WORKDIR_LIVE)/fsroot/boot/grub
	$(foreach file,$(INSTALLED_LIVEISOIMAGE_TARGET_INCLUDE_FILES),\
		ln $(file) $(GRUB_WORKDIR_LIVE)/fsroot/android/;)

	cat $(TARGET_GRUB_LIVE_CONFIGS) > $(GRUB_WORKDIR_LIVE)/fsroot/boot/grub/grub.cfg
	$(call process-bootmgr-cfg-common,$(GRUB_WORKDIR_LIVE)/fsroot/boot/grub/grub.cfg)
	$(call process-bootmgr-cfg-live,$(GRUB_WORKDIR_LIVE)/fsroot/boot/grub/grub.cfg)

	$(BOOTMGR_PATH_OVERRIDE) $(GRUB_PREBUILT_DIR)/bin/grub-mkrescue \
		-d $(GRUB_PREBUILT_DIR)/lib/grub/$(TARGET_GRUB_ARCH) \
		-o $(1) \
		--xorriso=$(BOOTMGR_XORRISO_EXEC) \
		$(GRUB_WORKDIR_LIVE)/fsroot
endef

endif # TARGET_GRUB_ARCH
endif # TARGET_BOOT_MANAGER

$(INSTALLED_LIVEISOIMAGE_TARGET): $(INSTALLED_LIVEISOIMAGE_TARGET_DEPS)
	$(call pretty,"Target Live ISO image: $@")
	$(call make-liveisoimage-target,$@)

.PHONY: liveisoimage
liveisoimage: $(INSTALLED_LIVEISOIMAGE_TARGET)

.PHONY: liveisoimage-nodeps
liveisoimage-nodeps:
	@echo "make $(INSTALLED_LIVEISOIMAGE_TARGET): ignoring dependencies"
	$(call make-liveisoimage-target,$(INSTALLED_LIVEISOIMAGE_TARGET))

endif # USES_DEVICE_PC_GENERIC_X86_64_PC
