module equations
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Module: equations
    !
    ! This module implements a system of ODEs by providing routines
    ! to query the size of the system's state vector, get initial
    ! conditions, and return the time-derivative of the state vector given
    ! the current state.
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    private :: euler_step

    public :: get_system_size, set_initial_state, f


contains


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: get_system_size
    !
    ! Description: Returns the size of the state vector used by the 
    !   system implemented in this module.
    !
    ! Input: none
    !
    ! Return value: the size of the system's state vector
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    function get_system_size()

        use parameters, only: state_size

        implicit none

        ! Return value
        integer :: get_system_size


        get_system_size = state_size

    end function get_system_size


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: set_initial_state
    !
    ! Description: Initializes a system state vector. Upon returning, 
    !   the elements of s have been set to contain the initial condition 
    !   of the system.
    !
    ! Input: none
    !
    ! Output: s -- the initial condition state vector
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine set_initial_state(s)

        use parameters, only: x0, y0, z0

        implicit none

        real, dimension(:), intent(out) :: s

        s(1) = x0
        s(2) = y0
        s(3) = z0

    end subroutine set_initial_state

    function euler_step(t, s, dt)
        use parameters, only: n, sigma, rho, beta

        implicit none

        real, intent(in) :: t, dt
        real, dimension(:), intent(in) :: s

        ! Return value
        real, dimension(size(s)) :: euler_step

        euler_step(1) = s(1) + dt * sigma * (s(2) - s(1))
        euler_step(2) = s(2) + dt * (s(1) * (rho - s(3)) - s(2))
        euler_step(3) = s(3) + dt * (s(1) * s(2) - beta * s(3))

    end function euler_step


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: f
    !
    ! Description: This function returns a tendency vector, ds/dt, for 
    !   the system implemented in this module, given the current state of 
    !   the system.
    !
    ! Input: t -- the time at which the state, s, is valid
    !        s -- a state vector
    !
    ! Return value: the time-derivative, ds/dt, for the system at s
    !        X[i + 1] = X[i] + dt * sigma * (Y[i] - X[i])
    !        Y[i + 1] = Y[i] + dt * (X[i] * (rho - Z[i]) - Y[i])
    !        Z[i + 1] = Z[i] + dt * (X[i] * Y[i] - beta * Z[i])
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    function f(t, s)
        use parameters, only : dt, n, sigma, rho, beta

        implicit none

        real, intent(in) :: t
        real, dimension(:), intent(in) :: s

        ! Return value
        real, dimension(size(s)) :: f

        f = euler_step(t, s, dt)

    end function f

end module equations
