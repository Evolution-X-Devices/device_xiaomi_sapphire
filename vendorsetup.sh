# ROM source patches

color="\033[0;32m"
end="\033[0m"

echo -e "${color}Applying patches${end}"
sleep 1

git clone https://github.com/Liekoo/packages_apps_FastCharge.git packages/apps/FastCharge

rm -rf device/xiaomi/sepolicy
git clone -b 16 https://github.com/lycodump/device_xiaomi_sepolicy.git device/xiaomi/sepolicy

rm -rf hardware/dolby
git clone -b 16 https://github.com/Pong-Development/hardware_dolby.git hardware/dolby

rm -rf hardware/xiaomi
git clone -b bka-no-dolby https://github.com/lycodump/hardware_xiaomi.git hardware/xiaomi
rm -rf hardware/xiaomi/FastCharge

echo "============================"
echo "Cloning hals"
echo "============================"
echo ""

rm -rf hardware/qcom-caf/sm6225/audio/agm
git clone -b 16-qpr2 https://github.com/lycodump/hardware_qcom-caf_sm6225_audio_agm.git hardware/qcom-caf/sm6225/audio/agm

rm -rf hardware/qcom-caf/sm6225/audio/pal
git clone -b 16-qpr2 https://github.com/lycodump/hardware_qcom-caf_sm6225_audio_pal.git hardware/qcom-caf/sm6225/audio/pal

rm -rf hardware/qcom-caf/sm6225/data-ipa-cfg-mgr
git clone -b 16-qpr2 https://github.com/lycodump/hardware_qcom-caf_sm6225_data-ipa-cfg-mgr.git hardware/qcom-caf/sm6225/data-ipa-cfg-mgr

rm -rf hardware/qcom-caf/sm6225/data-ipa-cfg-mgr/Android.bp

rm -rf hardware/qcom-caf/sm6225/dataipa
git clone -b 16-qpr2 https://github.com/lycodump/hardware_qcom-caf_sm6225_dataipa.git hardware/qcom-caf/sm6225/dataipa

rm -rf hardware/qcom-caf/sm6225/display
git clone -b bq2 https://github.com/lycodump/hardware_qcom_display.git hardware/qcom-caf/sm6225/display

rm -rf hardware/qcom-caf/sm6225/media
git clone -b sixteen https://github.com/lycodump/android_hardware_qcom-caf_sm6225_media.git hardware/qcom-caf/sm6225/media

rm -rf hardware/qcom-caf/sm6225/audio/primary-hal
git clone -b 16-qpr2 https://github.com/lycodump/hardware_qcom-caf_sm6225_audio_primary-hal.git hardware/qcom-caf/sm6225/audio/primary-hal

rm -rf device/qcom/sepolicy_vndr/sm6225
git clone -b 16-qpr2 https://github.com/lycodump/android_device_qcom_sepolicy_vndr_sm6225.git device/qcom/sepolicy_vndr/sm6225

echo "============================"
echo "Clone success"
echo "============================"
echo ""

echo "============================"
echo "Applying patches for Hw/Common"
echo "============================"
echo ""

# Get the Android build top directory
if [ -z "$ANDROID_BUILD_TOP" ]; then
    ANDROID_BUILD_TOP="$(pwd)"
fi

# Apply bengal_515 platform support patch
QCOM_CAF_COMMON="$ANDROID_BUILD_TOP/hardware/qcom-caf/common"

if [ -d "$QCOM_CAF_COMMON" ]; then
    echo -e "${color}Applying bengal_515 platform support...${end}"
    
    # Check if patches are already applied
    if ! grep -q "_515" "$QCOM_CAF_COMMON/BoardConfigQcom.mk" 2>/dev/null; then
        
        # Use a temp file approach for cleaner patching
        TEMP_FILE=$(mktemp)
        
        # Patch BoardConfigQcom.mk
        cat "$QCOM_CAF_COMMON/BoardConfigQcom.mk" > "$TEMP_FILE"
        
        # Replace QCOM_HARDWARE_VARIANT for UM_5_15_FAMILY
        sed -i '/else ifneq ($(filter $(UM_5_15_FAMILY)/,/^else ifneq/ {
            /QCOM_HARDWARE_VARIANT := sm8550$/c\
    ifeq ($(TARGET_BOARD_SUFFIX),_515)\
        QCOM_HARDWARE_VARIANT := sm6225\
    else\
        QCOM_HARDWARE_VARIANT := sm8550\
    endif
        }' "$TEMP_FILE" 2>/dev/null
        
        # Replace data-ipa-cfg-mgr namespace
        sed -i '/else ifneq ($(filter $(UM_5_15_FAMILY)/,/^else ifneq/ {
            /PRODUCT_SOONG_NAMESPACES += hardware\/qcom-caf\/sm8550\/data-ipa-cfg-mgr$/c\
        ifeq ($(TARGET_BOARD_SUFFIX),_515)\
            PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm6225/data-ipa-cfg-mgr\
        else\
            PRODUCT_SOONG_NAMESPACES += hardware/qcom-caf/sm8550/data-ipa-cfg-mgr\
        endif
        }' "$TEMP_FILE" 2>/dev/null
        
        cp "$TEMP_FILE" "$QCOM_CAF_COMMON/BoardConfigQcom.mk"
        
        # Patch os_pickup_sepolicy_vndr.mk
        sed -i '/else ifneq ($(filter $(UM_5_15_FAMILY)/,/^else ifneq/ {
            /include device\/qcom\/sepolicy_vndr\/sm8550\/SEPolicy.mk$/c\
    ifeq ($(TARGET_BOARD_SUFFIX),_515)\
        include device/qcom/sepolicy_vndr/sm6225/SEPolicy.mk\
    else\
        include device/qcom/sepolicy_vndr/sm8550/SEPolicy.mk\
    endif
        }' "$QCOM_CAF_COMMON/os_pickup_sepolicy_vndr.mk" 2>/dev/null
        
        # Patch qcom_defs.mk
        sed -i 's/UM_4_19_FAMILY := kona lito bengal/UM_4_19_FAMILY := kona lito\nifneq ($(TARGET_BOARD_SUFFIX),_515)\n    UM_4_19_FAMILY += bengal\nendif/' "$QCOM_CAF_COMMON/qcom_defs.mk" 2>/dev/null
        
        sed -i '/UM_5_15_FAMILY := kalama crow/a ifeq ($(TARGET_BOARD_SUFFIX),_515)\n    UM_5_15_FAMILY += bengal\nendif' "$QCOM_CAF_COMMON/qcom_defs.mk" 2>/dev/null
        
        rm -f "$TEMP_FILE"
    fi
    
    echo -e "${color}✓ bengal_515 patches applied${end}"
else
    echo "Warning: $QCOM_CAF_COMMON not found. Skipping patches."
fi
