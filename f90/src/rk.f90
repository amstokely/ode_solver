module rk
    implicit none

    private
    public :: rk2

contains

    function rk2(t, s, dt, f)
        use euler, only : euler_step
        use ode_interface, only : ode

        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s

        procedure(ode), pointer :: f

        real, dimension(size(s)) :: rk2

        real, dimension(size(s)) :: k1, k2

        k1 = euler_step(t, s, dt, f)
        k1 = 0.5*(s + k1)
        rk2 = s + dt*f(k1)

    end function rk2

end module rk