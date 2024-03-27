module DuplicateChecker
    implicit none
contains
    subroutine check_dupes(data, tolerance, dupes)
        ! This subroutine checks for duplicate images based on the specified tolerance
        ! Input:
        !   data - 3D array representing greyscale image data
        !   tolerance - tolerance for duplicate detection
        ! Output:
        !   dupes - 2D array to store duplicate information
        real, intent(in) :: data(:,:,:)   
        real, intent(in) :: tolerance
        logical, intent(out) :: dupes(size(data,2),size(data,3))
        integer :: i, j

        dupes(:,:) = .false.

        do i = 1, size(data, 1)
            j = i + 1
            do while (j <= size(data, 1))
                if (sum(abs(data(i, :, :) - data(j, :, :))) < tolerance*size(data, 2)**2) then
                    dupes(i, j) = .true.
                end if
                j = j + 1
            end do
        end do          
    end subroutine check_dupes 
end module DuplicateChecker

program test_check_dupes
    use DuplicateChecker
    implicit none
    real :: arr(3,10,10)
    logical :: dupes(3,3)
    integer :: i, j
    ! Read in data
    call random_number(arr)

    ! Check for duplicates
    call check_dupes(arr, .1, dupes)

    ! Print out duplicate information
    do i = 1, size(arr, 2)
        do j = 1, size(arr, 3)
            if (dupes(i, j)) then
                print *, 'Image ', i, ' is a duplicate of image ', j
            end if
        end do
    end do
end program test_check_dupes