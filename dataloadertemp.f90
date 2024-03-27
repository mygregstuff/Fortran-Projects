module dataloadertemp
    implicit none

contains

    subroutine load_data(files)
        character(len=*), intent(in) :: files(:)
        integer :: i, n

        ! Get the size of the 'files' array along its first dimension
        n = size(files)

        print *, "Number of files:", n

        ! Here you can implement code to load data from files
        ! For now, I'm just printing the filenames
        do i = 1, n
            print *, "File", i, ":", trim(files(i))
        end do

    end subroutine load_data

end module dataloadertemp

program testdataloader
    ! use dataloadertemp
    use nameloader
    implicit none
    character(len=100), dimension(:), allocatable :: loaded_names

    ! Call the subroutine to load data from a file
    call load_names('file_list.txt', loaded_names)
    ! pritn *, loaded_names
    ! call load_data(["file1.txt", "file2.txt", "file3.txt"])

end program testdataloader
