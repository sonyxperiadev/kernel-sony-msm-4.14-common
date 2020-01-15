#!/bin/sh

. "${0%/*}/build_shared_vars.sh"

# Cross Compiler
CC="clang"

# Build command
BUILD_ARGS="CLANG_TRIPLE=aarch64-linux-gnu"

# source shared parts
. "${0%/*}/build_shared.sh"
