CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)

AOSP_BUILD_TYPE ?= COMMUNITY-BUILD

AOSP_VERSION := aosPB-$(CURRENT_DEVICE)-$(shell date -u +%Y%m%d-%H%M)

# AOSP version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.aosp.version=$(AOSP_VERSION) \
    ro.aosp.releasetype=$(AOSP_BUILD_TYPE) \
    ro.aosp.build.version=$(CURRENT_DEVICE)-$(shell date -u +%Y%m%d-%H%M)

# Updater (only if production build)
ifeq ($(AOSP_BUILD_TYPE),PRODUCTION-BUILD)
PRODUCT_PACKAGES += Updater
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/init/init.system-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.system-updater.rc
PRODUCT_PACKAGE_OVERLAYS += vendor/aosp/overlay/Updater
endif
