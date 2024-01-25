! Created by astokely on 1/24/24.

module parameters
    !/*
    ! Module: parameters
    !
    ! This module contains the Lorenz parameters along with the general ODE solver parameters.
    !*/
    implicit none

    !/*dt: time step size!*/
    real :: dt
    !/*
    ! n: Total amount of time the system is evolved for. The total number of steps
    !    is n*dt
    ! state_size: The number of variables in the system (aka the dimension of the system).
    !*/
    integer :: n, state_size
    !/*output_file: The name of the file to write the output to.
    character(len=100) :: output_file

end module parameters