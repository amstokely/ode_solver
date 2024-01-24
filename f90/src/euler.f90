module euler
    implicit none
contains
    function euler_step(t, s, dt)
        use parameters, only : n, sigma, rho, beta

        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s

        ! Return value
        real, dimension(size(s)) :: euler_step

        euler_step(1) = s(1) + dt * sigma * (s(2) - s(1))
        euler_step(2) = s(2) + dt * (s(1) * (rho - s(3)) - s(2))
        euler_step(3) = s(3) + dt * (s(1) * s(2) - beta * s(3))

    end function euler_step

end module euler