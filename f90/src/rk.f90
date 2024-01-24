module rk
    implicit none

    private
    public :: rk2

contains

    function rk2(t, s, dt, f1, f2, f3)
        use parameters, only : sigma, beta, rho
        use euler, only : euler_step

        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s

        real, dimension(size(s)) :: rk2

        real, external :: f1, f2, f3
        real, dimension(size(s)) :: k1, k2

        k1 = euler_step(t, s, dt, f1, f2, f3)
        k1(1) = 0.5*(s(1) + k1(1))
        k1(2) = 0.5*(s(2) + k1(2))
        k1(3) = 0.5*(s(3) + k1(3))
        rk2(1) = s(1) + dt*f1(k1, dt)
        rk2(2) = s(2) + dt*f2(k1, dt)
        rk2(3) = s(3) + dt*f3(k1, dt)

    end function rk2

end module rk