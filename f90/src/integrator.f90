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

    public :: euler_step, euler_integrator

contains

    function euler_step(t, s) result(Y)
        use equations, only : f
        use settings_module, only : dt
        implicit none

        real, intent(in) :: t
        real, dimension(:), intent(in) :: s
        real, dimension(size(s)) :: Y

        Y = s + dt * f(t, s)

    end function euler_step

    subroutine euler_integrator(t, s)
        use observer, only : observer_write
        use settings_module, only : dt, n
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

    public :: rk2_integrator

contains

    function rk2_step(t, s)
        use euler_integrator_module, only : euler_step
        use equations, only : f
        use settings_module, only : dt

        implicit none

        real, intent(in) :: t
        real, dimension(:), intent(in) :: s

        real, dimension(size(s)) :: rk2_step
        real, dimension(size(s)) :: k1, k2

        k1 = euler_step(t, s)
        k1 = 0.5 * (s + k1)
        rk2_step = s + dt * f(t, k1)
    end function rk2_step

    subroutine rk2_integrator(t, s)
        use observer, only : observer_write
        use settings_module, only : dt, n
        implicit none

        real, intent(inout) :: t
        real, dimension(:), intent(inout) :: s
        integer :: i
        do i = 1, n
            s(:) = rk2_step(t, s)
            t = t + dt
            call observer_write(s)
        end do
    end subroutine rk2_integrator

end module rk_integrator_module

module integrator_module
    use abstract_integrator_module, only : abstract_integrator
    implicit none

    public :: integrator, integrator_init
    private :: integrator_name

    character(len = 256) :: integrator_name

    procedure(abstract_integrator), pointer :: integrator

contains
    subroutine integrator_init()
        use euler_integrator_module, only : euler_integrator
        use rk_integrator_module, only : rk2_integrator
        use settings_module, only : integrator_name
        implicit none

        if (trim(integrator_name) == 'rk2') then
            integrator => rk2_integrator
        else if (trim(integrator_name) == 'euler') then
            integrator => euler_integrator
        end if
    end subroutine integrator_init


end module integrator_module