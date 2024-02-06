module shallow_water_system_module
    private :: nx, ny, dx, dy
    integer :: nx, ny
    real :: dx, dy

contains
    function shallow_water_system(t, s) result(y)
        use iso_c_binding, only: c_f_pointer, c_loc
        implicit none
        real, intent(in) :: t
        real, dimension(:), target, intent(in) :: s
        real, dimension(:), pointer :: s_ptr
        real, pointer, dimension(:, :) :: u, v, h
        integer :: i, j
        real, dimension(size(s)) :: y
        s_ptr => s
        call c_f_pointer(c_loc(s_ptr(1)), u, [nx, ny])
        call c_f_pointer(c_loc(s_ptr(nx * ny + 1)), v, [nx, ny])
        call c_f_pointer(c_loc(s_ptr(2 * nx * ny + 1)), h, [nx, ny])




    end function shallow_water_system

end module shallow_water_system_module