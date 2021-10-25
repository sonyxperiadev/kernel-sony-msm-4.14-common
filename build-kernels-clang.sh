#!/bin/sh

. "${0%/*}/build_shared_vars.sh"


CLANG_R35=$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r353983c/bin/
CLANG_R41=$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r416183b/bin/

if [ -d "$CLANG_R35" ]; then
    echo "Using Clang (build r353983)"
    export CLANG=$CLANG_R35
elif  [ -d "$CLANG_R41" ]; then
    echo "Using Clang (build r416183b)"
    export CLANG=$CLANG_R41
fi

# Cross Compiler
CC="clang"

# Build command
BUILD_ARGS="CLANG_TRIPLE=aarch64-linux-gnu"

PATH=$CLANG:$PATH
# source shared parts
. "${0%/*}/build_shared.sh"
