# Check for 720p devices first
ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
    PRODUCT_COPY_FILES += \
        vendor/aosp/bootanimation/bootanimation_720.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip

else
    # Default to WHITE bootanimation
    BOOTANIMATION_VARIANT := white

    # Use BLACK if GEMENI bootanimation is enabled
    ifeq ($(TARGET_HAS_GEMENI_BOOTANIMATION),true)
        BOOTANIMATION_VARIANT := gemini
    endif

    PRODUCT_COPY_FILES += \
        vendor/aosp/bootanimation/bootanimation_$(BOOTANIMATION_VARIANT).zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
endif
