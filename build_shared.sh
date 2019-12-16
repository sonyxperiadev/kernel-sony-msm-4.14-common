set -e
# Check if mkdtimg tool exist
if [ ! -f "$MKDTIMG" ]; then
    echo "mkdtimg: File not found!"
    echo "Building mkdtimg"
    export ALLOW_MISSING_DEPENDENCIES=true
    make mkdtimg
fi

cd "$KERNEL_TOP"/kernel

echo "================================================="
echo "Your Environment:"
echo "ANDROID_ROOT: ${ANDROID_ROOT}"
echo "KERNEL_TOP  : ${KERNEL_TOP}"
echo "KERNEL_TMP  : ${KERNEL_TMP}"

for platform in $PLATFORMS; do \

    case $platform in
        yoshino)
            DEVICE=$YOSHINO;
            DTBO="false";;
        nile)
            DEVICE=$NILE;
            DTBO="false";;
        ganges)
            DEVICE=$GANGES;
            DTBO="false";;
        tama)
            DEVICE=$TAMA;
            DTBO="true";;
        kumano)
            DEVICE=$KUMANO;
            DTBO="true";;
    esac

    for device in $DEVICE; do \
        (
            KERNEL_TMP=$KERNEL_TMP-${device}
            [ ! "$keep_kernel_tmp" ] && rm -rf "${KERNEL_TMP}"
            mkdir -p "${KERNEL_TMP}"

            echo "================================================="
            echo "Platform -> ${platform} :: Device -> $device"
            make O="$KERNEL_TMP" ARCH=arm64 CROSS_COMPILE="$CROSS_COMPILE" -j$(nproc) ${BUILD_ARGS} aosp_$platform"_"$device\_defconfig

            echo "The build may take up to 10 minutes. Please be patient ..."
            echo "Building new kernel image ..."
            echo "Logging to $KERNEL_TMP/build.log"
            make O="$KERNEL_TMP" ARCH=arm64 CROSS_COMPILE="$CROSS_COMPILE" -j$(nproc) ${BUILD_ARGS} >"$KERNEL_TMP/build.log" 2>&1;

            echo "Copying new kernel image ..."
            ${CP_BLOB}-${device}
            if [ $DTBO = "true" ]; then
                $MKDTIMG create "$KERNEL_TOP"/common-kernel/dtbo-$device\.img "$(find "$KERNEL_TMP"/arch/arm64/boot/dts -name "*.dtbo")"
            fi
        )
    done
done


echo "================================================="
echo "Done!"
