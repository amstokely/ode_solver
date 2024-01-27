module lorenz_system
    !/*
    ! Module: lorenz
    !
    ! This module contains the functions that define the Lorenz system.
    ! By default, the sigma, rho, and beta parameters are set to 10, 28, and 8/3, respectively.
    !*/
    implicit none

    private
    public :: lorenz, sigma, rho, beta, x0, y0, z0, set_x0, set_y0, set_z0, set_sigma, set_rho, set_beta

    real :: sigma = 10.0, rho = 28.0, beta = 8.0/3.0, x0, y0, z0

contains
    subroutine set_x0(x0_arg)
        implicit none
        character(len=*), intent(in) :: x0_arg
        read(x0_arg, *) x0
    end subroutine set_x0

    subroutine set_y0(y0_arg)
        implicit none
        character(len=*), intent(in) :: y0_arg
        read(y0_arg, *) y0
    end subroutine set_y0

    subroutine set_z0(z0_arg)
        implicit none
        character(len=*), intent(in) :: z0_arg
        read(z0_arg, *) z0
    end subroutine set_z0

    subroutine set_sigma(sigma_arg)
        implicit none
        character(len=*), intent(in) :: sigma_arg
        read(sigma_arg, *) sigma
    end subroutine set_sigma

    subroutine set_rho(rho_arg)
        implicit none
        character(len=*), intent(in) :: rho_arg
        read(rho_arg, *) rho
    end subroutine set_rho

    subroutine set_beta(beta_arg)
        implicit none
        character(len=*), intent(in) :: beta_arg
        read(beta_arg, *) beta
    end subroutine set_beta
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