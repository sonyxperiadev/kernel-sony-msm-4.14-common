arguments=k
while getopts $arguments argument ; do
    case $argument in
        k) keep_kernel_tmp=t ;;
    esac
done

if [ -z "$ANDROID_BUILD_TOP" ]; then
    ANDROID_ROOT=$(realpath "$PWD")
    echo "ANDROID_BUILD_TOP not set, guessing root at $ANDROID_ROOT"
else
    ANDROID_ROOT="$ANDROID_BUILD_TOP"
fi

YOSHINO="lilac maple poplar"
NILE="discovery pioneer voyager"
GANGES="kirin mermaid"
TAMA="akari apollo akatsuki"
KUMANO="griffin bahamut"

PLATFORMS="yoshino nile ganges tama kumano"

# Mkdtimg tool
MKDTIMG=$ANDROID_ROOT/out/host/linux-x86/bin/mkdtimg
# Copy prebuilt kernel
CP_BLOB="cp $KERNEL_TMP/arch/arm64/boot/Image.gz-dtb $KERNEL_TOP/common-kernel/kernel-dtb"

KERNEL_TOP=$ANDROID_ROOT/kernel/sony/msm-4.14
# $KERNEL_TMP sub dir per script
KERNEL_TMP=$ANDROID_ROOT/out/${0##*-}/kernel-tmp

export PATH=$CLANG:$PATH:$ANDROID_ROOT/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export PATH=$PATH:$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
