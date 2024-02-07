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
        use system_module, only: system_size
        implicit none
        integer :: get_system_size
        get_system_size = system_size
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
        use system_module, only: system_initial_state
        implicit none
        real, dimension(:), allocatable, intent(out) :: s
        call system_initial_state(s)
    end subroutine set_initial_state


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
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    function f(t, s) result(y)
        use system_module, only : system
        implicit none

        real, intent(in) :: t
        real, dimension(:), intent(in) :: s
        real, dimension(size(s)) :: y
        y = system(t, s)

    end function f

end module equations
