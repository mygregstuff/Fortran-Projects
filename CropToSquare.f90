module CropToSquare
    implicit none
contains
    subroutine crop_array(arr)
        ! This subroutine crops the input array to a square shape
        ! Input/Output:
        !   arr - 2D array to be cropped
        real, intent(inout) :: arr(:,:)
        integer :: nrows, ncols, min_dim, i, j
        real, allocatable :: cropped_arr(:,:)

        nrows = size(arr, 1)
        ncols = size(arr, 2)
        min_dim = min(nrows, ncols)

        ! Allocate the cropped array
        allocate(cropped_arr(min_dim, min_dim))

        ! Calculate the indices for cropping
        i = (nrows - min_dim) / 2 + 1
        j = (ncols - min_dim) / 2 + 1

        ! Crop the array
        cropped_arr = arr(i:i+min_dim-1, j:j+min_dim-1)

        ! Replace the original array with the cropped array
        arr = cropped_arr
    end subroutine crop_array
end module CropToSquare

program test_crop_array
    use CropToSquare
    implicit none
    real, allocatable :: arr(:,:)
    integer :: i, j

    ! Allocate the array
    allocate(arr(3, 4))

    ! Fill the array with some values
    do i = 1, 3
        do j = 1, 4
            arr(i, j) = i + j
        end do
    end do

    ! Print the original array
    print *, "Original array:"
    do i = 1, 3
        print '(4F5.1)', (arr(i, j), j = 1, 4)
    end do

    ! Crop the array
    call crop_array(arr)

    ! Print the cropped array
    print *, "Cropped array:"
    do i = 1, size(arr, 1)
        print '(4F5.1)', (arr(i, j), j = 1, size(arr, 2))
    end do
end program test_crop_array
