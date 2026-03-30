# ROM source patches

color="\033[0;32m"
end="\033[0m"

echo -e "${color}Applying patches${end}"
sleep 1

git clone https://github.com/Liekoo/packages_apps_FastCharge.git packages/apps/FastCharge

rm -rf device/xiaomi/sepolicy
git clone -b 16 git@github.com:lycodump/device_xiaomi_sepolicy.git device/xiaomi/sepolicy

rm -rf hardware/dolby
git clone https://github.com/Evolution-X-Devices/hardware_dolby.git hardware/dolby

rm -rf hardware/xiaomi
git clone -b bka-no-dolby git@github.com:lycodump/hardware_xiaomi.git hardware/xiaomi
rm -rf hardware/xiaomi/FastCharge

echo "============================"
echo "Cloning hals"
echo "============================"
echo ""

rm -rf hardware/qcom-caf/sm6225/audio/agm
git clone -b 16-qpr2 git@github.com:lycodump/hardware_qcom-caf_sm6225_audio_agm.git hardware/qcom-caf/sm6225/audio/agm

rm -rf hardware/qcom-caf/sm6225/audio/pal
git clone -b 16-qpr2 git@github.com:lycodump/hardware_qcom-caf_sm6225_audio_pal.git hardware/qcom-caf/sm6225/audio/pal

rm -rf hardware/qcom-caf/sm6225/data-ipa-cfg-mgr
git clone -b 16-qpr2 git@github.com:lycodump/hardware_qcom-caf_sm6225_data-ipa-cfg-mgr.git hardware/qcom-caf/sm6225/data-ipa-cfg-mgr

rm -rf hardware/qcom-caf/sm6225/data-ipa-cfg-mgr/Android.bp

rm -rf hardware/qcom-caf/sm6225/dataipa
git clone -b 16-qpr2 git@github.com:lycodump/hardware_qcom-caf_sm6225_dataipa.git hardware/qcom-caf/sm6225/dataipa

rm -rf hardware/qcom-caf/sm6225/display
git clone -b bq2 git@github.com:lycodump/hardware_qcom_display.git hardware/qcom-caf/sm6225/display

rm -rf hardware/qcom-caf/sm6225/media
git clone -b sixteen git@github.com:lycodump/android_hardware_qcom-caf_sm6225_media.git hardware/qcom-caf/sm6225/media

rm -rf hardware/qcom-caf/sm6225/audio/primary-hal
git clone -b 16-qpr2 git@github.com:lycodump/hardware_qcom-caf_sm6225_audio_primary-hal.git hardware/qcom-caf/sm6225/audio/primary-hal

rm -rf device/qcom/sepolicy_vndr/sm6225
git clone -b 16-qpr2 git@github.com:lycodump/android_device_qcom_sepolicy_vndr_sm6225.git device/qcom/sepolicy_vndr/sm6225

rm -rf hardware/qcom-caf/sdm660 hardware/qcom-caf/sdm845 hardware/qcom-caf/sm8150 hardware/qcom-caf/sm8250 hardware/qcom-caf/sm8350 hardware/qcom-caf/sm8450 hardware/qcom-caf/sm8550 hardware/qcom-caf/sm8650 hardware/qcom-caf/sm8750

echo "============================"
echo "Clone success"
echo "============================"
echo ""