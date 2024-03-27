
module hello_world
    implicit none

contains

    subroutine hello_world_sub
        print *, "Hello, World!"
    end subroutine hello_world_sub

end module hello_world


program test
    use hello_world
    implicit none

    ! Call the subroutine
    call hello_world_sub

end program test



