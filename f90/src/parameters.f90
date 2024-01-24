! Created by astokely on 1/24/24.

module parameters
    !/*
    ! Module: parameters
    !
    ! This module contains the Lorenz parameters along with the general ODE solver parameters.
    !*/
    implicit none

    !/*sigma: Sigma constant in the Lorenz equations!*/
    real, parameter :: sigma = 10.0
    !/*rho: Rho constant in the Lorenz equations!*/
    real, parameter :: rho = 28.0
    !/*beta: Beta constant in the Lorenz equations!*/
    real, parameter :: beta = 2.66667
    !/*
    ! dt: time step size
    ! x0, y0, z0: initial conditions
    !*/
    real :: dt, x0, y0, z0
    !/*
    ! n: Total amount of time the system is evolved for. The total number of steps
    !    is n*dt
    ! state_size: The number of variables in the system (aka the dimension of the system).
    !*/
    integer :: n, state_size
    !/*output_file: The name of the file to write the output to.
    character(len=100) :: output_file

end module parameters