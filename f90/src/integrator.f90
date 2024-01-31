module abstract_integrator_module
    implicit none
    abstract interface
        subroutine abstract_integrator(t, s)
            implicit none
            real, intent(inout) :: t
            real, dimension(:), intent(inout) :: s
        end subroutine abstract_integrator
    end interface
end module abstract_integrator_module

module euler_integrator_module

    implicit none

    private :: euler_integrator_settings

    public :: euler_step, euler_integrator, euler_integrator_init, dt, n

    real :: dt
    integer :: n

    namelist /euler_integrator_settings/ dt, n

contains
    subroutine euler_integrator_init()
        implicit none
        character(len = 256) :: namelist_file
        call get_command_argument(1, namelist_file)
        open(unit = 10, file = namelist_file, status = 'old', action = 'read')
        read(10, nml = euler_integrator_settings)
        close(10)
    end subroutine euler_integrator_init

    function euler_step(t, s, step_size) result(Y)
        use equations, only : f
        implicit none

        real, intent(in) :: t
        real, intent(in), optional :: step_size
        real, dimension(:), intent(in) :: s
        real, dimension(size(s)) :: Y

        if (present(step_size)) then
            Y = s + step_size * f(t, s)
        else
            Y = s + dt * f(t, s)
        end if

    end function euler_step

    subroutine euler_integrator(t, s)
        use observer, only : observer_write
        implicit none

        real, intent(inout) :: t
        real, dimension(:), intent(inout) :: s
        integer :: i

        do i = 1, n
            s(:) = euler_step(t, s)
            t = t + dt
            call observer_write(s)
        end do
    end subroutine euler_integrator

end module euler_integrator_module


module rk_integrator_module
    implicit none

    private :: rk2_integrator_settings

    public :: rk2_integrator, rk2_integrator_init, dt, n

    real :: dt
    integer :: n

    namelist /rk2_integrator_settings/ dt, n


contains

    subroutine rk2_integrator_init()
        implicit none
        character(len = 256) :: namelist_file
        call get_command_argument(1, namelist_file)
        open(unit = 10, file = namelist_file, status = 'old', action = 'read')
        read(10, nml = rk2_integrator_settings)
        close(10)
    end subroutine rk2_integrator_init

    function rk2_step(t, s, dt)
        use euler_integrator_module, only : euler_step
        use equations, only : f

        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s

        real, dimension(size(s)) :: rk2_step
        real, dimension(size(s)) :: k1, k2

        k1 = euler_step(t, s, dt)
        k1 = 0.5 * (s + k1)
        rk2_step = s + dt * f(t, k1)
    end function rk2_step

    subroutine rk2_integrator(t, s)
        use observer, only : observer_write
        implicit none

        real, intent(inout) :: t
        real, dimension(:), intent(inout) :: s
        integer :: i

        do i = 1, n
            s(:) = rk2_step(t, s, dt)
            t = t + dt
            call observer_write(s)
        end do
    end subroutine rk2_integrator

end module rk_integrator_module

module integrator_module
    use abstract_integrator_module, only : abstract_integrator
    implicit none

    public :: integrator, integrator_init
    private :: integrator_settings, integrator_name

    character(len = 256) :: integrator_name
    namelist /integrator_settings/ integrator_name

    procedure(abstract_integrator), pointer :: integrator

contains
    subroutine integrator_init()
        use euler_integrator_module, only : euler_integrator_init, euler_integrator
        use rk_integrator_module, only : rk2_integrator_init, rk2_integrator
        implicit none

        character(len = 256) :: namelist_file
        call get_command_argument(1, namelist_file)
        open(unit = 10, file = namelist_file, status = 'old', action = 'read')
        read(10, nml = integrator_settings)
        close(10)
        if (integrator_name == 'rk2') then
            call rk2_integrator_init()
            integrator => rk2_integrator
        else if (integrator_name == 'euler') then
            call euler_integrator_init()
            integrator => euler_integrator
        end if
    end subroutine integrator_init


end module integrator_module