module lorenz_system
    !/*
    ! Module: lorenz
    !
    ! This module contains the functions that define the Lorenz system.
    ! By default, the sigma, rho, and beta parameters are set to 10, 28, and 8/3, respectively.
    !*/
    implicit none

    private
    public :: lorenz, sigma, rho, beta, x0, y0, z0

    real :: sigma = 10.0, rho = 28.0, beta = 8.0/3.0, x0, y0, z0

contains
    !/*
    ! Name: lorenz_dx
    !
    ! Description: This function returns the derivative of the x variable in the Lorenz system.
    !
    ! Input: s - The state vector of the system.
    !
    ! Return value: The derivative of the x variable.
    !*/
    function lorenz(t, s) result(y)
        implicit none
        real, intent(in) :: t
        real, dimension(:), intent(in) :: s
        real, dimension(size(s)) :: y

        y(1) = sigma*(s(2)-s(1))
        y(2) = s(1)*(rho-s(3))-s(2)
        y(3) = s(1)*s(2)-beta*s(3)
    end function lorenz

end module lorenz_system