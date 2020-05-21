#!/bin/sh

if [ -z "$SCHEME" ]
then
    echo "SCHEME not set. Invoke with SCHEME=[name of chez executable]"
    exit 1
fi

# Compile the bootstrap scheme
cd bootstrap
${SCHEME} --script compile.ss

# Put the result in the usual place where the target goes
mkdir -p ../build/exec
mkdir -p ../build/exec/idris2_app
install idris2-boot ../build/exec/idris2
install idris2_app/* ../build/exec/idris2_app

cd ..

# Install with the bootstrap directory as the PREFIX
DIR="`realpath $0`"
PREFIX="`dirname $DIR`"/bootstrap

# Now rebuild everything properly
echo ${PREFIX}

IDRIS2_BOOT_PATH="${PREFIX}/idris2-0.2.0/prelude:${PREFIX}/idris2-0.2.0/base:${PREFIX}/idris2-0.2.0/contrib:${PREFIX}/idris2-0.2.0/network"

make libs SCHEME=${SCHEME} PREFIX=${PREFIX}
make install SCHEME=${SCHEME} PREFIX=${PREFIX}
make clean IDRIS2_BOOT=${PREFIX}/bin/idris2
make all IDRIS2_BOOT=${PREFIX}/bin/idris2 SCHEME=${SCHEME} IDRIS2_PATH=${IDRIS2_BOOT_PATH}
make test INTERACTIVE='' IDRIS2_BOOT=${PREFIX}/bin/idris2 SCHEME=${SCHEME} IDRIS2_PATH=${IDRIS2_BOOT_PATH} IDRIS2_LIBS=${PREFIX}/idris2-0.2.0/lib IDRIS2_DATA=${PREFIX}/idris2-0.2.0/support
