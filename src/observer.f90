module observer
    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Module: observer
    !
    ! This module is used to "observe" the state vector of a
    ! system of equations by writing that state in some format to a file
    ! for later viewing or plotting by the user.
    !
    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    public :: observer_init, observer_write, observer_finalize

    character(len = 256) :: output_file, params
    integer :: ncid, varid, ts

contains

    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: observer_init
    !
    ! Description: Initializes the observer module by, e.g., opening
    ! files for later writing. This routine must be called before the
    ! first call to observer_write().
    !
    ! Input: none
    !
    ! Output: none
    !
    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    subroutine observer_init()
        use netcdf
        use netcdf_utils_module, only : check_error
        use equations, only : get_system_size
        use settings_module, only : output_file, n
        implicit none
        character(len = 256) :: namelist_file, name
        integer :: dimid(1)
        logical :: exists
        inquire(file = trim(output_file), exist = exists)
        if (exists) then
            ! delete the file
            open(unit = 10, file = trim(output_file), status = 'old')
            close(10, status = 'delete')
        end if
        call check_error(nf90_create(&
                path = trim(output_file), &
                cmode = nf90_netcdf4, &
                ncid = ncid&
                ), op_name = 'nf90_create')
        call check_error(nf90_def_dim(&
                ncid = ncid, &
                name = 'u', &
                len = nf90_unlimited, &
                dimid = dimid(1) &
                ), op_name = 'nf90_def_dim')
        call check_error(nf90_def_var(&
                ncid = ncid, &
                name = 's', &
                xtype = nf90_float, &
                dimids = dimid, &
                varid = varid &
                ), op_name = 'nf90_def_var')
        ts = 0
    end subroutine observer_init


    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: observer_write
    !
    ! Description: Formats and writes the contents of the state vector s
    ! to a file.
    !
    ! Input: s -- the state vector
    !
    ! Output: none
    !
    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine observer_write(s)
        use netcdf
        use settings_module, only : n
        use equations, only : get_system_size
        use netcdf_utils_module, only : check_error
        implicit none

        real, dimension(:), intent(in) :: s
        integer :: offset, i
        offset = size(s) / get_system_size()
        do i = 1, get_system_size()
            call check_error(nf90_put_var(&
                    ncid = ncid, &
                    varid = varid, &
                    values = s(1+(i-1)*offset:i*offset), &
                    start = [ts * offset + (i - 1) * n * offset + 1], &
                    count = [offset] &
                    ))


        end do
        ts = ts + 1
    end subroutine observer_write


    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! Name: observer_finalize
    !
    ! Description: Finalizes the observer module by, e.g., closing any
    ! files that were opened by the module. This routine must be called
    ! only once after all calls to observer_write() have been made.
    !
    ! Input: none
    !
    ! Output: none
    !
    ! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine observer_finalize()
        use netcdf
        use netcdf_utils_module, only : check_error
        implicit none

        call check_error(nf90_close(ncid), op_name = 'nf90_close')
    end subroutine observer_finalize

end module observer
