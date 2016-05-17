
config()
{
	function finish {
		cat config.log
  	}
 	trap finish EXIT
	options="--prefix=$PREFIX --disable-threads --with-lapack-stub "
	options=$options"--enable-plplot=no "
	# The following if statement allows the package to be built if
	# someone chooses to use their system libraries for fftw in place of
	# the package provided through eups. It checks if the eups fftw
	# environment variable is set, and if it is the configuration is
	# set appropriately.
	if [ "$FFTW_DIR" ]; then
		options=$options"--with-fftw-incdir=$FFTW_DIR/include "
		options=$options"--with-fftw-libdir=$FFTW_DIR/lib "

		# Workaround to enable detection of the hacked-up (prefixed)
		# LSST-built fftw library
		if [[ ! -z $FFTW_FUNC_PREFIX ]]; then
			for FUNC in fftwf_execute fftw_execute fftwf_init_threads fftw_init_threads; do
				sed -i "s| $FUNC| ${FFTW_FUNC_PREFIX}$FUNC|" configure
			done
		fi
	fi
	./configure ${options}
}

build()
{
	scons prefix=$PREFIX version=$VERSION
}

install()
{
	clean_old_install
	scons install prefix=$PREFIX version=$VERSION
}

