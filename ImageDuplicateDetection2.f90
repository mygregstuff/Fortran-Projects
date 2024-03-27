program ImageDuplicateDetection
    use iso_fortran_env, only: real32
    implicit none

    character(len=:), allocatable :: files(:)
    logical, allocatable :: duplicates(:,:)
    integer :: num_files
    real(real32) :: tolerance = 90.0_real32

    call get_image_files(files, num_files)
    allocate(duplicates(num_files, num_files))

    ! Loop through each pair of files
    do concurrent (i = 1:num_files-1, j = i+1:num_files)
        duplicates(i, j) = check_duplicates(files(i), files(j), tolerance)
    end do

    deallocate(files, duplicates)

contains

    subroutine get_image_files(files, num_files)
        character(len=:), allocatable, intent(out) :: files(:)
        integer, intent(out) :: num_files

        integer :: io_status, i
        character(len=256) :: file_name

        ! Open the file containing the list of files
        open(10, file='file_list.txt', status='old', action='read', iostat=io_status)
        if (io_status /= 0) error stop "Error opening file_list.txt"

        ! Count the number of lines in the file
        num_files = 0
        do
            read(10, '(A)', iostat=io_status) file_name
            if (io_status /= 0) exit
            num_files = num_files + 1
        end do
        rewind(10)

        ! Allocate and read file names into the 'files' array
        allocate(character(len=256) :: files(num_files))
        do i = 1, num_files
            read(10, '(A)', iostat=io_status) files(i)
            if (io_status /= 0) error stop "Error reading file name from file_list.txt"
        end do
        close(10)
    end subroutine get_image_files

    logical function check_duplicates(file1, file2, tolerance)
        character(len=*), intent(in) :: file1, file2
        real(real32), intent(in) :: tolerance
        real(real32), allocatable :: image_data1(:), image_data2(:)

        if (.not. read_image_data(file1, image_data1) .or. &
            .not. read_image_data(file2, image_data2)) then
            print *, "Error reading image data from files"
            check_duplicates = .false.
            return
        end if

        if (size(image_data1) /= size(image_data2)) then
            print *, "Error: Image sizes do not match"
            check_duplicates = .false.
            return
        end if

        diff = 2.0_real32 * sum(abs(data1 - data2)) / (sum(data1) + sum(data2)) * 100.0_real32
        is_duplicate = diff < tolerance
        deallocate(image_data1, image_data2)
    end function check_duplicates
end program ImageDuplicateDetection