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
