module lorenz_system_module
    implicit none

    public :: sigma, rho, beta, x0, y0, z0, lorenz_init, lorenz_system_size
    real :: sigma, rho, beta, x0, y0, z0
    integer, parameter :: lorenz_system_size = 3

contains

    real function get_real_variable(ncid, name)
        use netcdf
        implicit none
        integer, intent(in) :: ncid
        character(len = *), intent(in) :: name
        integer :: varid, status
        real :: value
        status = nf90_inq_varid(ncid, name, varid)
        status = nf90_get_var(ncid, varid, value)
        get_real_variable = value
    end function get_real_variable

    subroutine lorenz_init()
        use netcdf
        use settings_module, only : params
        implicit none
        integer :: ncid, status
        status = nf90_open(&
                path = trim(params), &
                mode = nf90_nowrite, &
                ncid = ncid&
                )
        sigma = get_real_variable(ncid, 'sigma')
        rho = get_real_variable(ncid, 'rho')
        beta = get_real_variable(ncid, 'beta')
        x0 = get_real_variable(ncid, 'x0')
        y0 = get_real_variable(ncid, 'y0')
        z0 = get_real_variable(ncid, 'z0')
    end subroutine lorenz_init

    subroutine lorenz_system_initial_state(s)
        implicit none
        real, dimension(:), allocatable, intent(out) :: s
        allocate(s(3))
        s(1) = x0
        s(2) = y0
        s(3) = z0
    end subroutine lorenz_system_initial_state

    function lorenz_system(t, s) result(y)
        implicit none
        real, intent(in) :: t
        real, dimension(:), target, intent(in) :: s
        real, dimension(size(s)) :: y

        y(1) = sigma * (s(2) - s(1))
        y(2) = s(1) * (rho - s(3)) - s(2)
        y(3) = s(1) * s(2) - beta * s(3)
    end function lorenz_system
end module lorenz_system_module