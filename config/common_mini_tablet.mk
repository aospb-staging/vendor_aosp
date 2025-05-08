# Inherit mobile mini common Lineage stuff
$(call inherit-product, vendor/aosp/config/common_mobile_mini.mk)

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/aosp/config/tablet.mk)

$(call inherit-product, vendor/aosp/config/telephony.mk)
