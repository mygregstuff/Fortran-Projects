program ImageDuplicateDetection
    use iso_fortran_env, only: real32
    implicit none
    character(:),allocatable :: files(:)
    logical,allocatable :: duplicates(:,:)
    integer :: n
    real(real32) :: tol=90.0
    call get_files(files,n)
    allocate(duplicates(n,n))
    do concurrent(i=1:n-1,j=i+1:n)duplicates(i,j)=check_dup(files(i),files(j),tol)
    deallocate(files,duplicates)
contains
    subroutine get_files(f,n)
        character(:),allocatable,intent(out) :: f(:)
        integer,intent(out) :: n
        integer :: io
        character(:),allocatable :: fn
        open(10,file='file_list.txt',status='old',action='read',iostat=io)
        if(io/=0)error stop'Error opening file_list.txt'
        n=0
        do;read(10,'(A)',iostat=io)fn;if(io/=0)exit;n=n+1;end do
        allocate(character(len(fn))::f(n))
        rewind(10)
        do i=1,n;read(10,'(A)',iostat=io)f(i);if(io/=0)error stop'Error reading file name'
        close(10)
    end subroutine get_files
    function check_dup(f1,f2,tol)
        character(*),intent(in) :: f1,f2
        real(real32),intent(in) :: tol
        real(real32),allocatable :: d1(:),d2(:)
        logical :: check_dup
        if(.not.read_image_data(f1,d1).or..not.read_image_data(f2,d2))then
            print*,'Error reading image data'
            check_dup=.false.
            return
        end if
        if(size(d1)/=size(d2))then
            print*,'Error: Image sizes mismatch'
            check_dup=.false.
            return
        end if
        diff=2.0_real32*sum(abs(d1-d2))/(sum(d1)+sum(d2))*100.0_real32
        check_dup=diff<tol
        deallocate(d1,d2)
    end function check_dup
end program ImageDuplicateDetection