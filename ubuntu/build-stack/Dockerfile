FROM alpine_moose_compiler:latest
WORKDIR /app
COPY . /app

ENV \
PACKAGES_DIR=/opt/moose \
STACK_SRC=/stack \
GCC_VERSION=7.3.0 \
MPICH_VERSION=3.2 \
PETSC_VERSION=3.8.3 \
PATH=$PACKAGES_DIR/gcc-$GCC_VERSION/bin:$PATH \
LD_LIBRARY_PATH=$PACKAGES_DIR/gcc-$GCC_VERSION/lib64:$PACKAGES_DIR/gcc-$GCC_VERSION/lib:$PACKAGES_DIR/gcc-$GCC_VERSION/lib/gcc/x86_64-unknown-linux-gnu/$GCC_VERSION:$PACKAGES_DIR/gcc-$GCC_VERSION/libexec/gcc/x86_64-unknown-linux-gnu/$GCC_VERSION:$LD_LIBRARY_PATH

RUN env \
run_script.sh
