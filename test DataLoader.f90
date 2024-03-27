module DataLoader
    use iso_fortran_env, only: real32
    implicit none

contains

    subroutine load_data(files)
        character(len=*), intent(in) :: files(:)

        integer :: i, n

        n = size(files)
        print *, "Number of files:", n

        ! Here you can implement code to load data from files
        ! For now, I'm just printing the filenames

        do i = 1, n
            print *, "File", i, ":", trim(files(i))
        end do

    end subroutine load_data

end module DataLoader
