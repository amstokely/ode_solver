module abstract_system_module
    abstract interface
        function abstract_system(t, s) result(y)
            implicit none
            real, intent(in) :: t
            real, dimension(:), intent(in) :: s
            real, dimension(size(s)) :: y
        end function abstract_system

        subroutine abstract_system_initial_state(s)
            implicit none
            real, dimension(:), allocatable, intent(out) :: s
        end subroutine abstract_system_initial_state

    end interface
end module abstract_system_module

module lorenz_system_module
    implicit none

    private :: lorenz_settings
    public :: lorenz_system, sigma, rho, beta, x0, y0, z0, lorenz_init, lorenz_system_size
    real :: sigma, rho, beta, x0, y0, z0
    integer, parameter :: lorenz_system_size = 3
    namelist /lorenz_settings/ x0, y0, z0, sigma, rho, beta

contains

    subroutine lorenz_init()
        implicit none
        character(len = 256) :: namelist_file
        call get_command_argument(1, namelist_file)
        sigma = 10.0
        rho = 28.0
        beta = 2.66667
        x0 = 10.0
        y0 = 0.0
        z0 = 10.0
        open(unit = 10, file = namelist_file, status = 'old', action = 'read')
        read(10, nml = lorenz_settings)
        close(10)
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
        real, dimension(:), intent(in) :: s
        real, dimension(size(s)) :: y

        y(1) = sigma * (s(2) - s(1))
        y(2) = s(1) * (rho - s(3)) - s(2)
        y(3) = s(1) * s(2) - beta * s(3)
    end function lorenz_system
end module lorenz_system_module

module system_module
    use abstract_system_module, only : abstract_system, abstract_system_initial_state
    implicit none

    public :: system, system_init, system_initial_state, system_size
    private :: system_settings, system_name

    character(len = 256) :: system_name
    namelist /system_settings/ system_name

    integer :: system_size
    procedure(abstract_system), pointer :: system
    procedure(abstract_system_initial_state), pointer :: system_initial_state

contains
    subroutine system_init()
        use lorenz_system_module, only : lorenz_system, lorenz_init, lorenz_system_initial_state, lorenz_system_size
        implicit none

        character(len = 256) :: namelist_file
        call get_command_argument(1, namelist_file)
        open(unit = 10, file = namelist_file, status = 'old', action = 'read')
        read(10, nml = system_settings)
        close(10)
        if (system_name == 'lorenz') then
            call lorenz_init()
            system => lorenz_system
            system_initial_state => lorenz_system_initial_state
            system_size = lorenz_system_size
        end if
    end subroutine system_init

end module system_module