YOSHINO="lilac maple poplar"
NILE="discovery pioneer voyager"
GANGES="kirin mermaid"
TAMA="akari apollo akatsuki"
KUMANO="griffin bahamut"
SEINE="pdx201"

PLATFORMS="yoshino nile ganges tama kumano seine"

find_repo_root()
# desc: Find root of a repo tree and echo it
{
    (
        max_depth=10
        while ! [ -e "$PWD/.repo" ] ; do
            [ $max_depth -eq 0 ] && return 1
            cd ..
            max_depth=$((max_depth-1))
        done
        echo "$PWD"
    )
}

usage(){
    cat <<EOF
Build kernel for supported devices
Usage: ${0##*/} [-k -d <device>]

Options:
-k              keep kernel tmp after build
-d <device>     only build the kernel for <device>
-O <directory>  build kernel in <directory>
-D <directory>  copy kernel/dtbo to <directory>
EOF
}

if [ -z "$ANDROID_BUILD_TOP" ]; then
    ANDROID_ROOT=$(find_repo_root)
    ANDROID_ROOT=$(realpath "$ANDROID_ROOT")
    echo "ANDROID_BUILD_TOP not set, guessing root at $ANDROID_ROOT"
else
    ANDROID_ROOT="$ANDROID_BUILD_TOP"
fi

PATH=$PATH:$ANDROID_ROOT/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
PATH=$PATH:$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin

# Mkdtimg tool
MKDTIMG=$ANDROID_ROOT/out/host/linux-x86/bin/mkdtimg

KERNEL_TOP=$ANDROID_ROOT/kernel/sony/msm-4.14
# $KERNEL_TMP sub dir per script
KERNEL_TMP=$ANDROID_ROOT/out/${0##*-}/kernel-tmp
OUT_OBJ_DEST="$KERNEL_TOP"/common-kernel

arguments=khd:O:D:
while getopts $arguments argument ; do
    case $argument in
        k) keep_kernel_tmp=t ;;
        d) only_build_for=$OPTARG;;
        O) KERNEL_TMP=$OPTARG;build_directory=$OPTARG;;
        D) OUT_OBJ_DEST=$OPTARG;modified_OUT_OBJ_DEST=t;;
        h) usage; exit 0;;
        ?) usage; exit 1;;
    esac
done

export PATH
