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

    private :: observer_settings, output_file

    public :: observer_init, observer_write, observer_finalize

    character(len=256) :: output_file

    namelist /observer_settings/ output_file

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
        character(len=256) :: namelist_file
        integer :: io_status
        call get_command_argument(1, namelist_file)
        open(unit=10, file=namelist_file, status='old', action='read')
        read(10, nml=observer_settings)
        close(10)

        open(unit=10, file=output_file, status='replace', action='write', iostat=io_status)

        if (io_status /= 0) then
            write(*,*) 'Error opening output file'
            stop
        end if

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
        write(10,*) s

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

        close(UNIT=10)
    end subroutine observer_finalize

end module observer
