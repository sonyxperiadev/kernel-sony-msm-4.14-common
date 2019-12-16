#!/bin/sh

cd ../../../..

. "$OLDPWD/build_shared_vars.sh"

# Cross Compiler
CLANG_CC="$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r370808/rbin/clang"

# Build command
BUILD_ARGS="CLANG_TRIPLE=aarch64-linux-gnu CC=$CLANG_CC"

# source shared parts
. "$OLDPWD/build_shared.sh"
