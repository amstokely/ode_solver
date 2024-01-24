module lorenz
    !/*
    ! Module: lorenz
    !
    ! This module contains the functions that define the Lorenz system.
    ! By default, the sigma, rho, and beta parameters are set to 10, 28, and 8/3, respectively.
    !*/
    implicit none

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
    function lorenz_dx(s)
        use parameters, only : sigma, rho, beta, dt
        implicit none
        real, intent(in) :: s(3)
        real :: lorenz_dx

        lorenz_dx = sigma*(s(2)-s(1))
    end function lorenz_dx

    !/*
    ! Name: lorenz_dy
    !
    ! Description: This function returns the derivative of the y variable in the Lorenz system.
    !
    ! Input: s - The state vector of the system.
    !
    ! Return value: The derivative of the y variable.
    !*/
    function lorenz_dy(s)
        use parameters, only : sigma, rho, beta, dt
        implicit none
        real, intent(in) :: s(3)
        real :: lorenz_dy

        lorenz_dy = s(1)*(rho-s(3))-s(2)
    end function lorenz_dy

    !/*
    ! Name: lorenz_dz
    !
    ! Description: This function returns the derivative of the z variable in the Lorenz system.
    !
    ! Input: s - The state vector of the system.
    !
    ! Return value: The derivative of the z variable.
    !*/
    function lorenz_dz(s)
        use parameters, only : sigma, rho, beta, dt
        implicit none
        real, intent(in) :: s(3)
        real :: lorenz_dz

        lorenz_dz = s(1)*s(2)-beta*s(3)
    end function lorenz_dz
end module lorenz