#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from xiaomi sm6225-common
$(call inherit-product, device/xiaomi/sm6225-common/common.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/xiaomi/sapphire/sapphire-vendor.mk)

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Fingerprint
TARGET_HAS_UDFPS := true

PRODUCT_PACKAGES += \
    vendor.xiaomi.hardware.fingerprintextension@1.0.vendor \
    vendor.xiaomi.hardware.fx.tunnel@1.0.vendor:64 \
    android.hardware.biometrics.fingerprint@2.1.vendor

# Init
$(call soong_config_set,libinit,vendor_init_lib,//$(LOCAL_PATH):init_sapphire)

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResSapphire \
    SettingsProviderResSapphire \
    SettingsResSapphire \
    SystemUIResSapphire \
    WifiResSapphire

# Sensors
PRODUCT_PACKAGES += \
    sensors.xiaomi.v2

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
