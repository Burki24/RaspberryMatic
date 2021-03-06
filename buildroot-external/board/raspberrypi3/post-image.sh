#!/bin/sh

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BR2_EXTERNAL_RASPBERRYMATIC_PATH}/board/${BOARD_NAME}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Use our own cmdline.txt+config.txt
cp "${BR2_EXTERNAL_RASPBERRYMATIC_PATH}/board/${BOARD_NAME}/cmdline.txt" "${BINARIES_DIR}/rpi-firmware/"
cp "${BR2_EXTERNAL_RASPBERRYMATIC_PATH}/board/${BOARD_NAME}/config.txt" "${BINARIES_DIR}/rpi-firmware/"

#
# Create user filesystem
#
echo "Create user filesystem"
mkdir -p ${BUILD_DIR}/userfs
touch "${BUILD_DIR}/userfs/.doFactoryReset"
mke2img -d ${BUILD_DIR}/userfs -G 4 -R 1 -B 300 -o ${BINARIES_DIR}/userfs.ext4

#
# VERSION File
#
cp ${TARGET_DIR}/boot/VERSION ${BINARIES_DIR}

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
