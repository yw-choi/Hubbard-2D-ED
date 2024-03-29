module ed_grid
    
    integer, public :: &
        nwloc           ! number of matsubara frequencies local to the node
    
    integer, allocatable, public :: &
        nw_procs(:),  & ! nw_procs(nprocs) number of matsubara frequencies for each processor
        nw_offsets(:)   ! nw_offsets(nprocs) global frequency index offsets 

    double precision, allocatable, public :: &
        w(:)
contains

    subroutine ed_grid_init
        use mpi
        use ed_params, only: nw, wmin, wmax
        integer :: namw, i
        double precision :: dw
        character(len=200) :: msg

        if (master) then
            write(*,*) "Setting up frequency grid..."
        endif

        nwloc = nw/nprocs
        namw = mod(nw,nprocs)
        if(taskid.lt.namw) nwloc=nwloc+1

        allocate(nw_procs(0:nprocs-1),nw_offsets(0:nprocs-1))
        call mpi_allgather(nwloc,1,mpi_integer,nw_procs(0),1,mpi_integer,comm,mpierr)

        nw_offsets(0) = 0
        do i = 1, nprocs-1
            nw_offsets(i) = nw_offsets(i-1) + nw_procs(i-1)
        enddo

        allocate(w(1:nwloc))
        if(taskid.lt.namw) then
            ishift = taskid*nwloc
            do i = 1, nwloc
                w(i) = (2.0D0*float(ishift+i-1)+1)*pi/beta
            enddo
        else
            ishift = namw+taskid*nwloc
            do i = 1, nwloc
                w(i) = (2.0D0*float(ishift+i-1)+1)*pi/beta
            enddo
        endif

        if (master) then
            write(*,'(a)') repeat("=",80)
            write(*,'(4x,a)') "Distribution of Matsubara Frequency Grid"
            write(*,'(a)') repeat("=",80)
            do i=1,nprocs
                write(*,'(4x,a4,I4,1x,a1,1x,I6)') "node",i,":",nw_procs(i-1)
            enddo
            write(*,'(4x,a,I6)') "Total    : ",nw
            write(*,'(a)') repeat("=",80)
            write(*,*)
        endif

    end subroutine ed_grid_init

end module ed_grid
