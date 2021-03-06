#!/bin/sh

set -e

BASEDIR=$(dirname "$0")
ARCHDIR=${BASEDIR}/../../

# executed from the top directory
runid=binary-$BEAT-$ARCH

cat ${BUILD_DIR}/package.yml ${ARCHDIR}/archs/$ARCH.yml > ${BUILD_DIR}/settings-$runid.yml
gotpl ${BASEDIR}/run.sh.j2 < ${BUILD_DIR}/settings-$runid.yml > ${BUILD_DIR}/run-$runid.sh
chmod +x ${BUILD_DIR}/run-$runid.sh

docker run --rm -v ${BUILD_DIR}:/build \
    -e BUILDID=$BUILDID -e SNAPSHOT=$SNAPSHOT -e RUNID=$runid \
    tudorg/fpm /build/run-$runid.sh

rm ${BUILD_DIR}/settings-$runid.yml ${BUILD_DIR}/run-$runid.sh
