# Updater
ifeq ($(CUSTOM_BUILDTYPE),OFFICIAL)
    PRODUCT_PACKAGES += \
        Updater

    PRODUCT_COPY_FILES += \
        vendor/aosp/prebuilt/common/etc/init/init.custom-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.custom-updater.rc
endif
