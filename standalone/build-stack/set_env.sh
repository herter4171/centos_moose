export PACKAGES_DIR=/opt/moose
export STACK_SRC=/stack
export GCC_VERSION=7.3.0
export MPICH_VERSION=3.2
export PETSC_VERSION=3.8.3
export PATH=$PACKAGES_DIR/gcc-$GCC_VERSION/bin:$PATH
export LD_LIBRARY_PATH=$PACKAGES_DIR/gcc-$GCC_VERSION/lib64:$PACKAGES_DIR/gcc-$GCC_VERSION/lib:$PACKAGES_DIR/gcc-$GCC_VERSION/lib/gcc/x86_64-unknown-linux-gnu/$GCC_VERSION:$PACKAGES_DIR/gcc-$GCC_VERSION/libexec/gcc/x86_64-unknown-linux-gnu/$GCC_VERSION:$LD_LIBRARY_PATH
