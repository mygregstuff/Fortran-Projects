module name_loader
   implicit none
contains
   subroutine load_names(filename, names)
      ! This subroutine loads the names of image files from a text file
      ! Input:
      !   filename - name of the text file containing the image file names
      ! Output:
      !   names - array of image file names
      character(len=*), intent(in) :: filename
      character(len=*), dimension(:), allocatable, intent(out) :: names
      integer :: num_names, i

      ! Open the file containing the list of names
      open(unit=10, file=filename, status='old', action='read')

      ! Count the number of names in the file
      num_names = 0
      do
         read(10, '(A)', iostat=i)
         if (i /= 0) exit  ! Exit loop when end of file is reached
         num_names = num_names + 1
      end do

      ! Allocate the names array
      allocate(names(num_names))

      ! Rewind the file to read from the beginning
      rewind(10)

      ! Read the names into the array
      do i = 1, num_names
         read(10, '(A)') names(i)
      end do

      ! Close the file
      close(10)
   end subroutine load_names
end module name_loader

program TestNameLoader
   use name_loader
   implicit none
   character(len=100), dimension(:), allocatable :: names
   integer :: i

   ! Load the names from the file
   call system("ls *.txt > file_list.text")
   call load_names('file_list.text', names)

   ! Print the names
   do i = 1, size(names)
      print *, names(i)
   end do
end program TestNameLoader
