module observer
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! Module: observer
!
! This module is used to "observe" the state vector of a 
! system of equations by writing that state in some format to a file
! for later viewing or plotting by the user.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    private

    public :: observer_init, observer_write, observer_finalize   


    contains


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: observer_init
    !
    ! Description: Initializes the observer module by, e.g., opening 
    !   files for later writing. This routine must be called before the 
    !   first call to observer_write().
    !
    ! Input: none
    !
    ! Output: none
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine observer_init()

        implicit none


        !
        ! Code...
        !

    end subroutine observer_init


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: observer_write
    !
    ! Description: Formats and writes the contents of the state vector s
    !   to a file.
    !
    ! Input: s -- the state vector
    !
    ! Output: none
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine observer_write(s)

        implicit none

        real, dimension(:), intent(in) :: s


        !
        ! Code...
        !

    end subroutine observer_write


    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: observer_finalize
    !
    ! Description: Finalizes the observer module by, e.g., closing any
    !   files that were opened by the module. This routine must be called 
    !   only once after all calls to observer_write() have been made.
    !
    ! Input: none
    !
    ! Output: none
    !
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine observer_finalize()

        implicit none


        !
        ! Code...
        !

    end subroutine observer_finalize

end module observer
