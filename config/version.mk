CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)

AOSP_BUILD_TYPE ?= COMMUNITY

KEYS_MK_PATH := vendor/lineage-priv/keys/keys.mk
KEYS_EXIST := $(shell [ -f $(KEYS_MK_PATH) ] && echo true || echo false)

# Signing
ifeq ($(KEYS_EXIST),true)
    $(warning keys.mk found, generating signed build)
    IS_SIGNED := true
    -include $(KEYS_MK_PATH)
else
    IS_SIGNED := false
endif

AOSP_VERSION := aosPB-$(CURRENT_DEVICE)-$(shell date -u +%Y%m%d-%H%M)$(if $(filter true,$(IS_SIGNED)),-signed)

# AOSP version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.aospb.maintainer=$(AOSPB_MAINTAINER) \
    ro.aosp.version=$(AOSP_VERSION) \
    ro.aosp.releasetype=$(AOSP_BUILD_TYPE) \
    ro.aosp.build.version=$(CURRENT_DEVICE)-$(AOSP_BUILD_TYPE)-$(shell date -u +%Y%m%d-%H%M) \
    ro.aosp.device=$(CURRENT_DEVICE)

# Updater (only if production build)
ifeq ($(AOSP_BUILD_TYPE),PRODUCTION-BUILD)
PRODUCT_PACKAGES += Updater
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/init/init.system-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.system-updater.rc
PRODUCT_PACKAGE_OVERLAYS += vendor/aosp/overlay/Updater
endif
