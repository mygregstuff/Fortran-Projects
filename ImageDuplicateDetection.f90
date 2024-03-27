program ImageDuplicateDetection
    use iso_fortran_env, only: real32
    implicit none
    
    ! Declarations
    character(len=256), allocatable :: files(:)
    logical, allocatable :: duplicates(:,:)
    integer :: num_files, i, j
    real(real32) :: tolerance = 90.0_real32
    
    ! Get the list of image files in the folder
    call get_image_files(files, num_files)

    ! Allocate array to store found duplicates
    allocate(duplicates(num_files, num_files))

    ! Loop through each pair of files
    do i = 1, num_files - 1
        do j = i + 1, num_files
            ! Check for duplicates
            duplicates(i, j) = check_duplicates(files(i), files(j), tolerance)
        end do
    end do
    
    ! Deallocate arrays
    deallocate(files)
    deallocate(duplicates)

contains

    subroutine get_image_files(files, num_files)
        character(len=256), allocatable, intent(out) :: files(:)
        integer, intent(out) :: num_files
        character(len=256) :: file_name
        integer :: io_status, i

        ! Open the file containing the list of files
        open(10, file='file_list.txt', status='old', action='read', iostat=io_status)
        if (io_status /= 0) then
            print *, "Error opening file_list.txt"
            stop
        end if

        ! Count the number of lines in the file
        num_files = 0
        do
            read(10, '(A)', iostat=io_status)
            if (io_status /= 0) exit  ! Exit loop when end of file is reached
            num_files = num_files + 1
        end do

        ! Allocate and read file names into the 'files' array
        allocate(files(num_files))
        rewind(10)
        do i = 1, num_files
            read(10, '(A)', iostat=io_status) file_name
            if (io_status /= 0) then
                print *, "Error reading file name from file_list.txt"
                deallocate(files)
                stop
            end if
            files(i) = file_name
        end do

        ! Close the file
        close(10)
    end subroutine get_image_files

    logical function check_duplicates(file1, file2, tolerance)
        character(len=*), intent(in) :: file1, file2
        real(real32), intent(in) :: tolerance
        real(real32), allocatable :: image_data1, image_data2
        integer :: n, io_status

        ! Check if files can be opened and read
        if (.not. read_image_data(file1, image_data1) .or. .not. read_image_data(file2, image_data2)) then
            print *, "Error reading image data from files"
            check_duplicates = .false.
            return
        end if

        ! Check if the arrays have the same size
        if (size(image_data1) /= size(image_data2)) then
            print *, "Error mismatched sizes"
            stop
        end if

        ! Calculate difference
        check_duplicates = 2 * sum(abs(image_data1 - image_data2)) / (sum(image_data1) + sum(image_data2)) * 100.0_real32 < tolerance
    end function check_duplicates
end program ImageDuplicateDetection
