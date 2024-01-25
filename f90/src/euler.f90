module euler
    !/*
    ! Module: euler
    !
    ! This module implements the Euler method for solving an N-dimensional system of ODEs.
    ! As of now, only forward Euler integration is supported for 3-dimensional systems.
    !*/

    implicit none

    private

    public :: euler_step

contains
    !/*
    ! Name: euler_step
    !
    ! Description: This function performs a single step of forward Euler integration according to the equation
    !              s(t + dt) = s(t) + dt*f(s(t), t).
    !
    ! Input: t - The current time.
    !        s - The current state vector.
    !        dt - The time step.
    !        f1 - The first function of the system of ODEs.
    !        f2 - The second function of the system of ODEs.
    !        f3 - The third function of the system of ODEs.
    !
    ! Return value: euler_step - The state vector after one time step.
    !*/
    function euler_step(t, s, dt, f1, f2, f3)

        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s

        real, dimension(size(s)) :: euler_step

        real, external :: f1, f2, f3

        euler_step(1) = s(1) + dt*f1(s, dt)
        euler_step(2) = s(2) + dt*f2(s, dt)
        euler_step(3) = s(3) + dt*f3(s, dt)
    end function euler_step

end module euler