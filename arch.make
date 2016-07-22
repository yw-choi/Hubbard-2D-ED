
FC      = mpif90
FFLAGS = -traceback -fast -no-ipo -xSSE4.2
#FFLAGS  = -traceback -C -CB -debug all -g

FFTW    = $(MKLROOT)/interfaces/fftw3xf/libfftw3xf_intel.a
ARPACK  = ~/opt/ARPACK/libarpack_OSX.a
PARPACK = ~/opt/ARPACK/parpack_MPI-OSX.a
MKL     = -mkl=sequential
LIBS    = $(MKL) $(PARPACK) $(ARPACK) $(FFTW)
################################################################
DEFS            = -DMPI 
#
.F.o:
	$(FC) -c $(FFLAGS)  $(DEFS) $<
.f.o:
	$(FC) -c $(FFLAGS)   $<
.F90.o:
	$(FC) -c $(FFLAGS)  $(DEFS) $<
.f90.o:
	$(FC) -c $(FFLAGS)   $<
#
