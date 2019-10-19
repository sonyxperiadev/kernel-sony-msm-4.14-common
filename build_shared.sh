# Check if mkdtimg tool exists
if [ ! -f $MKDTIMG ]; then
    echo "mkdtimg: File not found!"
    echo "Building mkdtimg"
    export ALLOW_MISSING_DEPENDENCIES=true
    make mkdtimg
fi

cd $KERNEL_TOP/kernel

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
        ret=$(rm -rf ${KERNEL_TMP} 2>&1);
        ret=$(mkdir -p ${KERNEL_TMP} 2>&1);
        if [ ! -d ${KERNEL_TMP} ] ; then
            echo "Check your environment";
            echo "ERROR: ${ret}";
            exit 1;
        fi

        echo "================================================="
        echo "Platform -> ${platform} :: Device -> $device"
        ret=$(${BUILD} aosp_$platform"_"$device\_defconfig 2>&1);
        case "$ret" in
            *"error"*|*"ERROR"*) echo "ERROR: $ret"; exit 1;;
        esac

        echo "The build may take up to 10 minutes. Please be patient ..."
        echo "Building new kernel image ..."
        echo "Logging to $KERNEL_TMP/build_log_${device}"
        $BUILD >$KERNEL_TMP/build_log_${device} 2>&1;

        echo "Copying new kernel image ..."
        ret=$(${CP_BLOB}-${device} 2>&1);
        case "$ret" in
            *"error"*|*"ERROR"*) echo "ERROR: $ret"; exit 1;;
        esac
        if [ $DTBO = "true" ]; then
            $MKDTIMG create $KERNEL_TOP/common-kernel/dtbo-$device\.img `find $KERNEL_TMP/arch/arm64/boot/dts -name "*.dtbo"`
        fi
    done
done


echo "================================================="
echo "Clean up environment"
echo "Done!"
unset ANDROID_ROOT
unset KERNEL_TOP
unset KERNEL_CFG
unset KERNEL_TMP
unset BUILD
