module data_loader_txt
   implicit none
contains
   subroutine load_data(data_file, shape_file, color_arr)
      implicit none
      integer :: iostat
      character(len=100), intent(in) :: data_file, shape_file
      real, allocatable, dimension(:) :: color_arr_flat
      real, dimension(:,:,:), allocatable, intent(out) :: color_arr
      integer, dimension(3) :: shape_arr

      ! Read shape data
      open(unit=10, file=shape_file, status='old', iostat=iostat)
      print *, iostat, "opening shape file"
      read(10, *, iostat=iostat) shape_arr
      print *, iostat, "reading shape file"
      close(10)

      ! Allocate and read color data
      allocate(color_arr_flat(product(shape_arr)))
      open(unit=20, file=data_file, status='old', iostat=iostat)
      print *, iostat, "opening data file"
      read(20, *, iostat=iostat) color_arr_flat
      print *, iostat, "reading data file"
      close(20)

      ! Reshape color data
      allocate(color_arr(shape_arr(1), shape_arr(2), shape_arr(3)), stat=iostat)
      print *, iostat, "allocating color_arr"
      color_arr = reshape(color_arr_flat, shape_arr)

   end subroutine load_data
end module data_loader_txt

program test_data_loader
   use data_loader_txt
   use name_loader
   implicit none
   character(len=256), dimension(:), allocatable :: files
   real, dimension(:,:,:), allocatable :: arr
   real, allocatable, dimension(:,:,:,:) :: color_data
   integer :: i

   call system("ls *.txt > file_list.text")
   call load_names("filenames.text", files)
!    print *, files
!    do i=1, size(files), 2
!       call load_data(files(i+1), files(i), arr)
!       color_data(i,:,:,:) = arr
!       print *, color_data(i,1,1,:)
!    end do

end program test_data_loader
