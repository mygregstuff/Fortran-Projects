module DataLoader
    use netcdf
    implicit none   
contains
    subroutine load_data(files, arr)
        implicit none
        integer, dimension(:), allocatable :: dimids, dim_len
        integer :: ncid, varid, status, i, ndims
        character(len=*), intent(in) :: files
        real, dimension(:), allocatable, intent(out) :: arr  

        ! Open the CDF4 file for reading from memory
        status = nf90_open(trim(files(1)), nf90_nowrite, ncid)
        if (status /= nf90_noerr) then
            print *, "Error opening CDF4 file."
            stop
        endif

        ! ! Get the variable ID
        ! status = nf90_inq_varid(ncid, "your_varible_name", varid)
        ! if (status /= nf90_noerr) then
        !     print *, "Error getting variable ID."
        !     call nf90_close(ncid)
        !     stop
        ! endif

        ! ! Get the number of dimensions of the variable
        ! status = nf90_inquire_variable(ncid, varid, ndims = ndims)
        ! if (status /= nf90_noerr) then
        !     print *, "Error getting number of dimensions."
        !     call nf90_close(ncid)
        !     stop
        ! endif

        ! ! Allocate arrays for dimension IDs and lengths
        ! allocate(dimids(ndims))
        ! allocate(dim_len(ndims))

        ! ! Get the dimension IDs
        ! status = nf90_inquire_variable(ncid, varid, dimids = dimids)
        ! if (status /= nf90_noerr) then
        !     print *, "Error getting dimension IDs."
        !     call nf90_close(ncid)
        !     stop
        ! endif

        ! ! Get the lengths of the dimensions
        ! do i = 1, ndims
        !     status = nf90_inquire_dimension(ncid, dimids(i), len = dim_len(i))
        !     if (status /= nf90_noerr) then
        !         print *, "Error getting dimension length."
        !         call nf90_close(ncid)
        !         stop
        !     endif
        ! end do

        ! ! Allocate array for data
        ! allocate(arr(prod(dim_len)))

        ! ! Read the data from the variable
        ! status = nf90_get_var(ncid, varid, arr)
        ! if (status /= nf90_noerr) then
        !     print *, "Error reading data."
        !     call nf90_close(ncid)
        !     stop
        ! endif

        ! ! Close the CDF4 file
        ! status = nf90_close(ncid)
        ! if (status /= nf90_noerr) then
        !     print *, "Error closing CDF4 file."
        !     stop
        ! endif
    end subroutine load_data
end module DataLoader


program TestDataLoader
    use DataLoader
    implicit none
    character(len=*) :: files
    real, allocatable :: color_data(:)
    integer :: i

    ! Set file names
    files = './96 - 2y6nhaY.nc'

    print *, shape(files)

    ! Load data
    call load_data(files, color_data)

    ! Print data
    ! do i = 1, size(files,1)
    !     print *, 'Data from file ', trim(files(i))
    !     ! print *, color_data
    ! end do
end program TestDataLoader

