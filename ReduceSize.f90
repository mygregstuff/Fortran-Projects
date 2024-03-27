module ReduceSize
    use iso_fortran_env, only: real32
    implicit none
contains
    subroutine bin_data(arr,bins,out_arr)
        ! Calculate the bin size
        real, intent(in) :: arr(:,:)
        integer, intent(in) :: bins
        real, intent(out) :: out_arr(bins,bins)
        integer :: bin_size, i, j
        bin_size = size(arr, 1) / bins
        ! Loop through the binned data array
        do i = 1, bins
            do j = 1, bins
                ! Calculate the average value for each bin
                out_arr(i, j) = sum(arr((i-1)*bin_size+1:i*bin_size, (j-1)*bin_size+1:j*bin_size)) / real(bin_size)**2
            end do
        end do
    end subroutine bin_data    
end module ReduceSize

program test_reduce_size
    use ReduceSize
    implicit none
    real, dimension(100,100) :: arr
    real, dimension(10,10) :: out_arr
    integer :: i, j
    ! Fill the array with random numbers
    call random_number(arr)
    ! Call the binning subroutine
    call bin_data(arr, 10, out_arr)
    ! Print the binned array
    do i = 1, 10
        do j = 1, 10
            write(*, '(F6.2, " ")', advance="no") out_arr(i, j)
        end do
        write(*, *)
    end do
end program test_reduce_size
