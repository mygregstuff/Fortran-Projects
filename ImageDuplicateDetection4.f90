! module NameLoader
!     implicit none
! contains
!     subroutine load_names(filename, names)
!         ! This subroutine loads the names of image files from a text file
!         ! Input:
!         !   filename - name of the text file containing the image file names
!         ! Output:
!         !   names - array of image file names
!         character(len=*), intent(in) :: filename
!         character(len=256), dimension(:), allocatable, intent(out) :: names
!         integer :: num_names, i

!         ! Open the file containing the list of names
!         open(unit=10, file=filename, status='old', action='read')

!         ! Count the number of names in the file
!         num_names = 0
!         do
!             read(10, '(A)', iostat=i)
!             if (i /= 0) exit  ! Exit loop when end of file is reached
!             num_names = num_names + 1
!         end do

!         ! Allocate the names array
!         allocate(names(num_names))

!         ! Rewind the file to read from the beginning
!         rewind(10)

!         ! Read the names into the array
!         do i = 1, num_names
!             read(10, '(A)') names(i)
!         end do

!         ! Close the file
!         close(10)
!     end subroutine load_names
! end module NameLoader

! module DataLoader
!     implicit none   
! contains
!     subroutine load_data(file, color_data)
!         ! This subroutine loads the color data from image files
!         ! Input:
!         !   file - name of the dat file
!         ! Output:
!         !   color_data - 3D array to store color image data
!         character(len=256), intent(in) :: file
!         real, allocatable, intent(out) :: color_data(:,:,:) ! 3D array to store image data
!         integer :: io_status, i, j, k

!         open(unit=20, file=trim(file), status='old', action='read', iostat=io_status)
!         if (io_status /= 0) then
!             print *, 'Error opening file: ', trim(file)
!         end if

!         read(20, *, iostat=io_status) i, j, k ! Read dimensions from file
!         if (io_status /= 0) then
!             print *, 'Error reading dimensions from file: ', trim(file)
!             close(20)
!         end if

!         ! Allocate memory for the color data array
!         allocate(color_data(i, j, k))

!         ! Read data from file
!         read(20, *, iostat=io_status) color_data
!         if (io_status /= 0) then
!             print *, 'Error reading data from file: ', trim(file)
!             close(20)
!         end if

!         ! Close file
!         close(20)
        
!     end subroutine load_data
! end module DataLoader

! module Greyscale
!     implicit none
! contains
!     subroutine convert_to_greyscale(arr,greyarr)
!         ! This subroutine converts the input RGB array to greyscale
!         ! Input:
!         !   arr - 3D array representing RGB image
!         real, intent(in) :: arr(:,:,:)
!         real, allocatable, intent(out) :: greyarr(:,:)
!         integer :: i, j
!         real :: r, g, b

!         allocate(greyarr(size(arr,1),size(arr,2)))

!         ! Loop over the rows and columns of the array
!         do i = 1, size(arr, 1)
!             do j = 1, size(arr, 2)
!                 ! Get the red, green, and blue values
!                 r = arr(i, j, 1)
!                 g = arr(i, j, 2)
!                 b = arr(i, j, 3)

!                 ! Convert to greyscale using weighted average
!                 greyarr(i, j) = 0.2989 * r + 0.5870 * g + 0.1140 * b
!             end do
!         end do
!     end subroutine convert_to_greyscale
! end module Greyscale

! module CropToSquare
!     implicit none
! contains
!     subroutine crop_array(arr)
!         ! This subroutine crops the input array to a square shape
!         ! Input/Output:
!         !   arr - 2D array to be cropped
!         real, intent(inout) :: arr(:,:)
!         integer :: nrows, ncols, min_dim, i, j
!         real, allocatable :: cropped_arr(:,:)

!         nrows = size(arr, 1)
!         ncols = size(arr, 2)
!         min_dim = min(nrows, ncols)

!         ! Allocate the cropped array
!         allocate(cropped_arr(min_dim, min_dim))

!         ! Calculate the indices for cropping
!         i = (nrows - min_dim) / 2 + 1
!         j = (ncols - min_dim) / 2 + 1

!         ! Crop the array
!         cropped_arr = arr(i:i+min_dim-1, j:j+min_dim-1)

!         ! Replace the original array with the cropped array
!         arr = cropped_arr
!     end subroutine crop_array
! end module CropToSquare

! module ReduceSize
!     use iso_fortran_env, only: real32
!     implicit none
! contains
!     subroutine bin_data(arr,bins,out_arr)
!         ! Calculate the bin size
!         real, intent(in) :: arr(:,:)
!         integer, intent(in) :: bins
!         real, intent(out) :: out_arr(bins,bins)
!         integer :: bin_size, i, j
!         bin_size = size(arr, 1) / bins
!         ! Loop through the binned data array
!         do i = 1, bins
!             do j = 1, bins
!                 ! Calculate the average value for each bin
!                 out_arr(i, j) = sum(arr((i-1)*bin_size+1:i*bin_size, (j-1)*bin_size+1:j*bin_size)) / real(bin_size)**2
!             end do
!         end do
!     end subroutine bin_data    
! end module ReduceSize

! module DuplicateChecker
!     implicit none
! contains
!     subroutine check_dupes(data, tolerance, dupes)
!         ! This subroutine checks for duplicate images based on the specified tolerance
!         ! Input:
!         !   data - 3D array representing greyscale image data
!         !   tolerance - tolerance for duplicate detection
!         ! Output:
!         !   dupes - 2D array to store duplicate information
!         real, intent(in) :: data(:,:,:)   
!         real, intent(in) :: tolerance
!         logical, intent(out) :: dupes(size(data,2),size(data,3))
!         integer :: i, j

!         dupes(:,:) = .false.

!         do i = 1, size(data, 1)
!             j = i + 1
!             do while (j <= size(data, 1))
!                 if (sum(abs(data(i, :, :) - data(j, :, :))) < tolerance*size(data, 2)**2) then
!                     dupes(i, j) = .true.
!                 end if
!                 j = j + 1
!             end do
!         end do          
!     end subroutine check_dupes 
! end module DuplicateChecker

program DupeDetector
    use NameLoader ! Import the NameLoader module
    ! use DataLoader ! Import the DataLoader module
    ! use GreyScale ! Import the GreyScale module
    ! use CropToSquare ! Import the CovertToSquare module
    ! use ReduceSize ! Import the ReduceSize module
    ! use DuplicateChecker ! Import the DuplicateChecker module
    implicit none

    ! Declarations
    character(len=256), allocatable :: files(:) ! Array to store the names of image files
    logical, allocatable :: dupes(:,:) ! Array to store the duplicate information
    integer :: i, j ! Loop variables
    real :: tol = 0.1 ! Tolerance for duplicate detection
    real, allocatable :: cdata(:,:,:,:) ! Array to store color data
    real, allocatable :: gdata(:,:,:) ! Array to store greyscale data
    real, allocatable :: sdata(:,:,:) ! Array to store reduced size data
    real, allocatable :: arr(:,:,:) ! Array to store reduced size data


    ! Get the list of image files in the folder
    ! print *, system("ls *.dat") ! Print the list of .dat files in the current directory
    call system("ls *.nc > file_list.txt") ! Save the list of .dat files to a text file
    call load_names("file_list.txt", files) ! Load the names of image files from the text file

    ! print *, "files:", size(files) ! Print the number of files

    ! ! Read data for each file
    ! do i = 1, size(files)
    !     call load_data(files(i), arr) ! Load the color data for each file
    !     cdata(i,:,:,:)=arr
    ! end do

    ! allocate(gdata(size(files), :,:)) ! Allocate memory for the greyscale data array

    ! ! Convert images to greyscale
    ! do i = 1, size(cdata, 1)
    !     call convert_to_greyscale(cdata(i,:,:,:),gdata(i,:,:)) ! Convert each color image to greyscale
    ! end do

    ! ! Crop images to square shape   
    ! do i = 1, size(gdata, 1)
    !     call crop_to_square(gdata(i, :,:)) ! Crop each greyscale image to a square shape
    ! end do

    ! ! Reduce the size of the images
    ! call bin_data(gdata,100,sdata) ! Bin the greyscale images to reduce their size

    ! ! Check for duplicate images
    ! call check_dupes(sdata, tol, dupes) ! Check for duplicate images based on the specified tolerance

    ! ! Print the duplicate images
    ! do i = 1, size(files)
    !     do j = i + 1, size(files)
    !         if (dupes(i, j)) then
    !             print *, trim(files(i)), 'is a duplicate of', trim(files(j)) ! Print the names of duplicate images
    !         end if
    !     end do
    ! end do

end program DupeDetector