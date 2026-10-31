#!/bin/sh
# =====================================================
# FBV - static build and strip
# =====================================================
# Exit immediately if any command fails
set -e

# Change directory to where this script lives
cd "$(dirname "$0")"

# Read version safely from repository files
VERSION=$(cat VERSION 2>/dev/null || echo "1.0b")
export VERSION

# Parse options
DO_STRIP=0
for arg in "$@"; do
    case "$arg" in
        --strip)
            DO_STRIP=1
            shift
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Usage: $0 [--strip]"
            exit 1
            ;;
    esac
done

echo "=================================================="
echo " Building Statically Linked fbv v${VERSION} for initramfs"
echo "=================================================="

echo " -> Cleaning up workspace caches..."
make distclean

echo " -> Generating minimal build profiles..."
cat << EOF > config.h
#define IDSTRING "fbv ${VERSION}"
#define DEFAULT_FRAMEBUFFER "/dev/fb0"
#define FBV_SUPPORT_GIF
#define FBV_SUPPORT_JPEG
#define FBV_SUPPORT_PNG
#define FBV_SUPPORT_BMP
EOF

cat << EOF > Make.conf
prefix  = \$(CURDIR)/build
bindir  = \$(prefix)/bin
mandir  = \$(prefix)/man
infodir = \$(prefix)/info
LIBS    =
EOF

echo " -> Compiling static binary with GCC..."
make

echo " -> Installing to local staging directory..."
make install

TARGET_BIN="./build/bin/fbv"

# Handle binary stripping if requested
if [ "$DO_STRIP" -eq 1 ]; then
    echo " -> Stripping debug symbols to minimize file size..."
    if [ -f "$TARGET_BIN" ]; then
        echo "PRE STRIP: $(du -sh "$TARGET_BIN" | cut -f1)"
        file "$TARGET_BIN"

        strip "$TARGET_BIN"

        echo "POST STRIP: $(du -sh "$TARGET_BIN" | cut -f1)"
        file "$TARGET_BIN"
    fi
fi

echo " -> Verifying compiled artifact architecture..."
if [ -f "$TARGET_BIN" ]; then
    echo " -> Success! Binary built at: ${TARGET_BIN}"
    echo "--------------------------------------------------"
    file "$TARGET_BIN"
    echo "--------------------------------------------------"

    if ldd "$TARGET_BIN" 2>&1 | grep -q "not a dynamic executable"; then
        echo "Verification Complete: Truly 100% Statically Linked."
    else
        echo "Warning: Binary compiled, but dynamic references detected by ldd!"
    fi

    echo " -> Creating portable deployment archive..."
    tar -zcvf "fbv-static-${VERSION}.tar.gz" build/ > /dev/null
    echo " -> Archive created: fbv-static-${VERSION}.tar.gz"
else
    echo "Fatal Error: Standalone binary was not generated successfully."
    exit 1
fi

echo "=================================================="
echo " Build Process Completed Successfully."
echo "=================================================="
