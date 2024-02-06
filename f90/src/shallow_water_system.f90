module shallow_water_system_module
    private :: nx, ny, dx, dy
    integer :: nx, ny
    real :: dx, dy

contains
    function shallow_water_system(t, s) result(y)
        use iso_c_binding, only : c_f_pointer, c_loc
        implicit none
        real, intent(in) :: t
        real, dimension(:), target, intent(in) :: s
        real, dimension(size(s)), target :: y
        real, dimension(:), pointer :: s_ptr
        real, dimension(:), pointer :: y_ptr
        real, pointer, dimension(:, :) :: s_u, s_v, s_h
        real, pointer, dimension(:, :) :: y_u, y_v, y_h
        integer :: i, j, i_m1, i_p1, j_m1, j_p1
        s_ptr => s
        y_ptr => y
        call c_f_pointer(c_loc(s_ptr(1)), s_u, [nx, ny])
        call c_f_pointer(c_loc(s_ptr(nx * ny + 1)), s_v, [nx, ny])
        call c_f_pointer(c_loc(s_ptr(2 * nx * ny + 1)), s_h, [nx, ny])
        call c_f_pointer(c_loc(y_ptr(1)), y_u, [nx, ny])
        call c_f_pointer(c_loc(y_ptr(nx * ny + 1)), y_v, [nx, ny])
        call c_f_pointer(c_loc(y_ptr(2 * nx * ny + 1)), y_h, [nx, ny])
        do i = 1, nx
            if (i == 1) then
                i_m1 = nx
                i_p1 = 2
            else if (i == nx) then
                i_p1 = 1
                i_m1 = nx - 1
            else
                i_m1 = i - 1
                i_p1 = i + 1
            end if
            do j = 1, ny
                if (j == 1) then
                    j_m1 = ny
                    j_p1 = 2
                else if (j == ny) then
                    j_p1 = 1
                    j_m1 = ny - 1
                else
                    j_m1 = j - 1
                    j_p1 = j + 1
                end if
                y_u(i, j) = -s_u(i, j) * ((s_u(i_p1, j) - s_u(i_m1, j)) / (2 * dx)) &
                        - s_v(i, j) * ((s_u(i, j_p1) - s_u(i, j_m1)) / (2 * dy)) &
                        - 9.81 * ((s_h(i_p1, j) - s_h(i_m1, j)) / (2 * dx))
                y_v(i, j) = -s_u(i, j) * ((s_v(i_p1, j) - s_v(i_m1, j)) / (2 * dx)) &
                        - s_v(i, j) * ((s_v(i, j_p1) - s_v(i, j_m1)) / (2 * dy)) &
                        - 9.81 * ((s_h(i, j_p1) - s_h(i, j_m1)) / (2 * dy))
                y_h(i, j) = -s_u(i, j) * ((s_h(i_p1, j) - s_h(i_m1, j)) / (2 * dx)) &
                        - s_v(i, j) * ((s_h(i, j_p1) - s_h(i, j_m1)) / (2 * dy)) &
                        - s_h(i, j) * ((s_u(i_p1, j) - s_u(i_m1, j)) / (2 * dx)) &
                        - s_h(i, j) * ((s_v(i, j_p1) - s_v(i, j_m1)) / (2 * dy))
            end do
        end do


    end function shallow_water_system

end module shallow_water_system_module