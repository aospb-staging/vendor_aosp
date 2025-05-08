CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)

AOSP_BUILD_TYPE ?= COMMUNITY-BUILD

AOSP_VERSION := aosPB-$(CURRENT_DEVICE)-OTA-$(shell date -u +%Y%m%d-%H%M)

# AOSP version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.aosp.version=$(AOSP_VERSION) \
    ro.aosp.releasetype=$(AOSP_BUILD_TYPE)
