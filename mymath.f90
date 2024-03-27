module mymath
contains
  function myfunction(x) result(r)
    real, intent(in) :: x
    real             :: r
    r = sin(x)
  end function
end module