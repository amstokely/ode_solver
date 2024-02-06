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
