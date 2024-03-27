module NameLoader
    implicit none
contains

    subroutine load_names(filename, names)
        character(len=*), intent(in) :: filename
        character(len=256), dimension(:), allocatable, intent(out) :: names
        integer :: num_names, i

        ! Open the file containing the list of names
        open(unit=10, file=filename, status='old', action='read')

        ! Count the number of names in the file
        num_names = 0
        do
            read(10, '(A)', iostat=i)
            if (i /= 0) exit  ! Exit loop when end of file is reached
            num_names = num_names + 1
        end do

        ! Allocate the names array
        allocate(names(num_names))

        ! Rewind the file to read from the beginning
        rewind(10)

        ! Read the names into the array
        do i = 1, num_names
            read(10, '(A)') names(i)
        end do

        ! Close the file
        close(10)
    end subroutine load_names

end module NameLoader

program TestNameLoader
    use NameLoader
    implicit none
    character(len=256), dimension(:), allocatable :: loaded_names

    ! Call the subroutine to load names from a file
    call load_names('names.txt', loaded_names)

    ! Output the loaded names
    print *, "Loaded names:"
    do i = 1, size(loaded_names)
        print *, loaded_names(i)
    end do
end program TestNameLoader
