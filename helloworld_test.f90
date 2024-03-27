! module hello_world
!     implicit none

! contains

!     subroutine hello_world
!         print *, "Hello, World!"
!     end subroutine hello_world

! end module hello_world


program test_hello_world
    use HelloWorld
    implicit none

    ! Call the subroutine
    call hello_world

end program test_hello_world

! gfortran -arch arm64 -o helloworld helloworld.f90 -> still doesnt work
    ! output:
! Undefined symbols for architecture arm64:
!   "___helloworld_MOD_hello_world", referenced from:
!       _MAIN__ in ccOTidpS.o
! ld: symbol(s) not found for architecture arm64
! collect2: error: ld returned 1 exit status

! gfortran -o helloworld helloworld.f90 -> stil doesnt work
    ! output:
! f951: Error: Unexpected end of file in 'tempCodeRunnerFile.f90'

! gfortran -o helloworld helloworld.f90 -> stil doesnt work
    ! output:
! Undefined symbols for architecture arm64:
!   "___helloworld_MOD_hello_world", referenced from:
!       _MAIN__ in ccjwQlh5.o
! ld: symbol(s) not found for architecture arm64
! collect2: error: ld returned 1 exit status
 
 ! gfortran -arch arm64 -o helloworld helloworld.f90 helloworld.mod -> stil doesnt work


