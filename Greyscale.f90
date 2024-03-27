module Greyscale
    implicit none
contains
    subroutine convert_to_greyscale(arr,greyarr)
        ! This subroutine converts the input RGB array to greyscale
        ! Input:
        !   arr - 3D array representing RGB image
        real, intent(in) :: arr(:,:,:)
        real, allocatable, intent(out) :: greyarr(:,:)
        integer :: i, j
        real :: r, g, b

        allocate(greyarr(size(arr,1),size(arr,2)))

        ! Loop over the rows and columns of the array
        do i = 1, size(arr, 1)
            do j = 1, size(arr, 2)
                ! Get the red, green, and blue values
                r = arr(i, j, 1)
                g = arr(i, j, 2)
                b = arr(i, j, 3)

                ! Convert to greyscale using weighted average
                greyarr(i, j) = 0.2989 * r + 0.5870 * g + 0.1140 * b
            end do
        end do
    end subroutine convert_to_greyscale
end module Greyscale

program test_convert_to_greyscale
    use Greyscale
    implicit none
    real, allocatable :: arr(:,:,:)
    real, allocatable :: greyarr(:,:)
    integer :: i, j, k

    ! Allocate the array
    allocate(arr(100,100,3))

    ! Fill the array with random values
    call random_number(arr)

    ! Convert to greyscale
    call convert_to_greyscale(arr, greyarr)

    ! Print the greyscale array
    do i = 1, size(greyarr, 1)
        do j = 1, size(greyarr, 2)
            write(*, '(F5.2, " ")', advance="no") greyarr(i, j)
        end do
        write(*, *)
    end do
end program test_convert_to_greyscale
