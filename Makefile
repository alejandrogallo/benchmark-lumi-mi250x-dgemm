test-cublas-parallel: test-cublas-parallel.cxx
	CC \
	  -I. \
	  -xhip \
	  test-cublas-parallel.cxx  \
	  -lhipblas \
	  -o test-cublas-parallel
