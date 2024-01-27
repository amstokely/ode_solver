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
    !        f - The function that defines the system of ODEs.
    !
    ! Return value: euler_step - The state vector after one time step.
    !*/
    function euler_step(t, s, dt, f) result(Y)
        use ode_system, only: ode
        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s
        procedure(ode), pointer, intent(in) :: f

        real, dimension(size(s)) :: Y


        Y(:) = s(:) + dt*f(t, s)
    end function euler_step

end module euler