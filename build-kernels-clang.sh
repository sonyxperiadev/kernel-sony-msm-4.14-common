cd ../../../..

. "$OLDPWD/build_shared_vars.sh"

# Cross Compiler
CLANG_CC="$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r370808/rbin/clang"

# Build command
BUILD="make O=$KERNEL_TMP ARCH=arm64 CC=$CLANG_CC CLANG_TRIPLE=aarch64-linux-gnu CROSS_COMPILE=$GCC_CC -j$(nproc)"

# source shared parts
. "$OLDPWD/build_shared.sh"
