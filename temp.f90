program test_data_loader
    use data_loader_txt
    use nameloader
    implicit none
    character(len=100) :: file, shape_file
    character(len=:), dimension(:), allocatable :: files
    real, allocatable, dimension(:,:,:) :: color_data
    real, allocatable, dimension(:,:,:,:) :: color_datas
    integer :: i, iostat

    ! Set file names
    file = '96 - 2y6nhaY.txt'
    shape_file = '96 - 2y6nhaY.shape.txt'

    ! Load data
    call load_data(file, shape_file, color_data)
    print *, color_data(1,1,:)

    ! Execute command and store result in files
    filename = 'output.txt'

    ! Execute the command and redirect output to a file
    cmd = "ls *.txt > " // trim(filename)
    call system(trim(cmd))

    ! Determine the number of lines in the file
    open(unit=10, file=filename, status='old', action='read')
    n = 0
    do
        read(10, *, end=100, iostat=iostat)
        if (iostat /= 0) exit
        n = n + 1
    end do
    100 continue

    ! Allocate the array and read the file names
    allocate(files(n))
    rewind(10)
    do i = 1, n
        read(10, '(A)', iostat=iostat) files(i)
    end do
    close(10)
    print *, iostat, files

    ! Allocate color_datas
    allocate(color_datas(shape(files,1)/2,:,:,3))

    print *, files
    do i=1,shape(files,1),2
        print *, files(i)
        call load_data(files(i+1), files(i), color_datas((i+1)/2,:,:,:))
        print *, color_datas(i,1,1,:)
    end do

end program test_data_loader
