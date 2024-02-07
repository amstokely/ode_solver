module shallow_water_system_module
    private :: nx, ny, dx, dy
    public :: shallow_water_init, &
            shallow_water_system_initial_state, &
            shallow_water_system, &
            shallow_water_system_size
    integer :: nx, ny, shallow_water_system_size
    real :: dx, dy
    real, allocatable, dimension(:), target :: ic

contains

    subroutine shallow_water_init()
        use netcdf
        use netcdf_utils_module, only : get_integer_variable, get_real_variable, get_real_array_variable
        use iso_c_binding, only : c_f_pointer, c_loc
        use settings_module, only : params
        implicit none
        integer :: ncid, status, i
        status = nf90_open(&
                path = trim(params), &
                mode = nf90_nowrite, &
                ncid = ncid&
                )
        nx = get_integer_variable(ncid, "nx")
        ny = get_integer_variable(ncid, "ny")
        dx = get_real_variable(ncid, "dx")
        dy = get_real_variable(ncid, "dy")
        ic = get_real_array_variable(ncid, "ic")
        status = nf90_close(ncid)
        shallow_water_system_size = 3
    end subroutine shallow_water_init

    subroutine shallow_water_system_initial_state(s)
        use iso_c_binding, only : c_f_pointer, c_loc
        implicit none
        real, dimension(:), allocatable, intent(out) :: s
        integer :: i, j
        allocate(s(3 * nx * ny))
        s(:) = ic(:)
    end subroutine shallow_water_system_initial_state

    function shallow_water_system(t, s) result(y)
        use iso_c_binding, only : c_f_pointer, c_loc
        implicit none
        real, intent(in) :: t
        real, dimension(:), target, intent(in) :: s
        real, dimension(size(s)), target :: y
        real, pointer, dimension(:, :) :: s_u, s_v, s_h
        real, pointer, dimension(:, :) :: y_u, y_v, y_h
        integer :: i, j, i_m1, i_p1, j_m1, j_p1
        s_u(1:nx, 1:ny) => s(1:nx * ny)
        s_v(1:nx, 1:ny) => s(nx * ny + 1:2 * nx * ny)
        s_h(1:nx, 1:ny) => s(2 * nx * ny + 1:3 * nx * ny)
        y_u(1:nx, 1:ny) => y(1:nx * ny)
        y_v(1:nx, 1:ny) => y(nx * ny + 1:2 * nx * ny)
        y_h(1:nx, 1:ny) => y(2 * nx * ny + 1:3 * nx * ny)
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
        print *, "t = ", t
        print *, "s_u = ", s_u(50, 50), "s_v = ", s_v(50, 50), "s_h = ", s_h(50, 50)
        print *, "y_u = ", y_u(50, 50), "y_v = ", y_v(50, 50), "y_h = ", y_h(50, 50)
        print *, "-----------------------------------------------------------------"
    end function shallow_water_system

end module shallow_water_system_module