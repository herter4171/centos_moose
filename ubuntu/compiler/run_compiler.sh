build_gcc()
{
	# Set build dir
	GCC_BUILD=$STACK_SRC/gcc-build
	
	cd $STACK_SRC/gcc-$GCC_VERSION
	./contrib/download_prerequisites
	
	# Clear any old build files, then go to build directory
	if [ -d $GCC_BUILD ]; then rm -rf $GCC_BUILD; fi
	mkdir $GCC_BUILD
	cd $GCC_BUILD
	
	
	# Configure
	../gcc-$GCC_VERSION/configure --prefix=$PREFIX_GCC \
		--disable-multilib \
		--enable-languages=c,c++,fortran,jit \
		--enable-checking=release \
		--enable-host-shared \
		--with-pic \
		CC=gcc \
		CXX=g++ \
		CFLAGS="-O3"
	
	# Make and install
	make -j 6
	make install
}


build_mpich()
{
	# Set build dir
	MPICH_BUILD=$STACK_SRC/mpich-$MPICH_VERSION/gcc-build
	
	# Clear any old build files, then go to build directory
	if [ -d $MPICH_BUILD ]; then rm -rf $MPICH_BUILD; fi
	mkdir $MPICH_BUILD
	cd $MPICH_BUILD
	
	# Configure
	../configure --prefix=$PREFIX_MPICH \
	--enable-shared \
	--enable-sharedlibs=gcc \
	--enable-fast=03 \
	--enable-debuginfo \
	--enable-totalview \
	--enable-two-level-namespace \
	CC=gcc \
	CXX=g++ \
	FC=gfortran \
	F77=gfortran \
	F90='' \
	CFLAGS='' \
	CXXFLAGS='' \
	FFLAGS='' \
	FCFLAGS='' \
	F90FLAGS='' \
	F77FLAGS=''
	
	# Make and install
	make -j 6
	make install
}

build_petsc()
{
	# Set build dir
	PETSC_BUILD=$STACK_SRC/petsc-$PETSC_VERSION
	cd $STACK_SRC
	tar -xf petsc-$PETSC_VERSION.tar.gz -C $STACK_SRC
	cd $PETSC_BUILD
	
	# Add packages
	apt-get update -y
	apt-get install cmake -y	
	
	
	# Configure
	./configure \
	--prefix=$PREFIX_PETSC \
	--download-hypre=1 \
	--with-ssl=0 \
	--with-debugging=no \
	--with-pic=1 \
	--with-shared-libraries=1 \
	--with-cc=mpicc \
	--with-cxx=mpicxx \
	--with-fc=mpif90 \
	--download-fblaslapack=1 \
	--download-metis=1 \
	--download-parmetis=1 \
	--download-superlu_dist=1 \
	--download-mumps=1 \
	--download-scalapack=1 \
	--CC=mpicc --CXX=mpicxx --FC=mpif90 --F77=mpif77 --F90=mpif90 \
	--CFLAGS='-fPIC -fopenmp' \
	--CXXFLAGS='-fPIC -fopenmp' \
	--FFLAGS='-fPIC -fopenmp' \
	--FCFLAGS='-fPIC -fopenmp' \
	--F90FLAGS='-fPIC -fopenmp' \
	--F77FLAGS='-fPIC -fopenmp' \
	PETSC_DIR=`pwd`
	
	# Make and install
	make PETSC_DIR=$PETSC_BUILD PETSC_ARCH=arch-linux2-c-opt all
	make PETSC_DIR=$PETSC_BUILD PETSC_ARCH=arch-linux2-c-opt install
	#make PETSC_DIR=$PREFIX_PETSC PETSC_ARCH="" test

}

###############################################################################
# ENSURE GCC
###############################################################################

export PREFIX_GCC=$PACKAGES_DIR/gcc-$GCC_VERSION
{
	if [ ! -f $PREFIX_GCC/bin/g++ ]; then
		build_gcc
	else
		echo "Found gcc-$GCC_VERSION at $PREFIX_GCC"
	fi

	export PATH=$$PREFIX_GCC:$PATH
	export LD_LIBRARY_PATH=$PREFIX_GCC/lib64:$PREFIX_GCC/lib:$PREFIX_GCC/lib/gcc/x86_64-unknown-linux-gnu/7.3.1:$PREFIX_GCC/libexec/gcc/x86_64-unknown-linux-gnu/7.3.1:$LD_LIBRARY_PATH
}


###############################################################################
# ENSURE MPICH
###############################################################################

export PREFIX_MPICH=$PACKAGES_DIR/mpich-$MPICH_VERSION
{
	if [ ! -f $PREFIX_MPICH/bin/mpicxx ]; then
	    build_mpich
	else
		echo "Found mpich-$MPICH_VERSION at $PREFIX_MPICH"
	fi


	export PATH=$PREFIX_MPICH/bin:$PATH
	export CC=mpicc
	export CXX=mpicxx
	export FC=mpif90
	export F90=mpif90
	export C_INCLUDE_PATH=$PREFIX_MPICH/include:$C_INCLUDE_PATH
	export CPLUS_INCLUDE_PATH=$PREFIX_MPICH/include:$CPLUS_INCLUDE_PATH
	export FPATH=$PREFIX_MPICH/include:$FPATH
	export MANPATH=$PREFIX_MPICH/share/man:$MANPATH
	export LD_LIBRARY_PATH=$PREFIX_MPICH/lib:$LD_LIBRARY_PATH
}


###############################################################################
# ENSURE PETSC
############################################################################### 

export PREFIX_PETSC=$PACKAGES_DIR/petsc-$PETSC_VERSION
{
	if [ ! -f $PREFIX_PETSC/bin/petscmpiexec ]; then
		build_petsc
		
		printf "Run tests on petsc-$PETSC_VERSION (y/N): "
		read run_tests
	
		for yes_char in "y" "Y" ; do
			if [ $(echo $run_tests | grep -c $yes_char) -gt 0 ]; then
				echo "Running tests"
				cd $STACK_SRC/petsc-$PETSC_VERSION
				make PETSC_DIR=$PREFIX_PETSC PETSC_ARCH="" test
				break
			fi
		done
	else
		echo "Found petsc-$PETSC_VERSION at $PREFIX_PETSC"
	fi
	
	
	
	export PETSC_DIR=$PREFIX_PETSC
	echo "PETSC_DIR=$PETSC_DIR"
}

###############################################################################
# ENSURE LIBMESH
###############################################################################

for curr_path in  /projects /projects/moose /projects/moose/libmesh ; do
	echo "CURR PATH: $curr_path\n"
	ls $curr_path
done

cd $PROJECTS_DIR/moose/scripts
./update_and_rebuild_libmesh.sh

###############################################################################
# EXPORT ENVIRONMENT
###############################################################################

if [ $(cat /root/.bashrc | grep -c PACKAGES_DIR) -eq 0 ]; then
printf "
export PACKAGES_DIR=$PACKAGES_DIR
export PATH=$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$C_INCLUDE_PATH
export FPATH=$FPATH
export MANPATH=$MANPATH
export PETSC_DIR=$PETSC_DIR
export CC=$CC
export CXX=$CXX
export FC=$FC
export F90=$F90

" >> /root/.bashrc
fi

###############################################################################
# RUN MOOSE TESTS
###############################################################################

apt-get update -y
apt-get install python-dev -y

cd $PROJECTS_DIR/moose/test
make -j 6
./run_tests -j 6