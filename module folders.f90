module folders
! Declerations



contains
    subroutine get_script_path(path)
        character(len=*), intent(out) :: path
        character(len=256) :: command_line
        integer :: i

        ! Get the command line that started the program
        call get_command_argument(0, command_line)

        ! Find the last occurrence of the path separator '/'
        do i = len_trim(command_line), 1, -1
            if (command_line(i:i) == '/') then
                path = command_line(1:i)
                return  ! Return the script directory
            end if
        end do
    end subroutine get_script_path

        subroutine set_working_directory(path)
        character(len=*), intent(in) :: path

        ! Set the working directory
        call chdir(trim(adjustl(path)))
    end subroutine set_working_directory
end module folders