module netcdf_utils_module
contains
    subroutine check_error(netcdf_op, op_name, file_name)
        use netcdf
        implicit none
        integer, intent(in) :: netcdf_op
        character(len = *), intent(in), optional :: file_name
        character(len = *), intent(in), optional :: op_name
        character(len = 1000) :: error_message

        if (netcdf_op /= 0) then
            error_message = "----------------------------------------------------" // achar(10) &
                    // " ERROR" // achar(10)
            if (present(op_name)) then
                error_message = trim(error_message) // " Function: " // op_name // achar(10)
            end if
            if (present(file_name)) then
                error_message = trim(error_message) // " File: " // file_name // achar(10)
            end if
            error_message = trim(error_message) // " Error message: " // nf90_strerror(netcdf_op) // achar(10) &
                    // "----------------------------------------------------" &
                    // achar(10)
            write(*, *) trim(error_message)
            stop
        end if
    end subroutine check_error

    integer function get_integer_variable(ncid, name)
        use netcdf
        implicit none
        integer, intent(in) :: ncid
        character(len = *), intent(in) :: name
        integer :: varid
        integer :: value
        integer :: status
        call check_error(&
                nf90_inq_varid(ncid = ncid, name = name, varid = varid), &
                op_name = "nf90_inq_varid" &
                )
        call check_error(&
                nf90_get_var(ncid = ncid, varid = varid, values = value), &
                op_name = "nf90_get_var" &
                )
        get_integer_variable = value
    end function get_integer_variable

    real function get_real_variable(ncid, name)
        use netcdf
        implicit none
        integer, intent(in) :: ncid
        character(len = *), intent(in) :: name
        integer :: varid, status
        real :: value
        call check_error(&
                nf90_inq_varid(ncid = ncid, name = name, varid = varid), &
                op_name = "nf90_inq_varid" &
                )
        call check_error(&
                nf90_get_var(ncid = ncid, varid = varid, values = value), &
                op_name = "nf90_get_var" &
                )
        get_real_variable = value
    end function get_real_variable

    function get_real_array_variable(ncid, name) result(value)
        use netcdf
        implicit none
        integer, intent(in) :: ncid
        character(len = *), intent(in) :: name
        integer :: varid, status, dimid, len
        integer :: dimids(1)
        real, allocatable, dimension(:) :: value
        call check_error(&
                nf90_inq_varid(ncid = ncid, name = name, varid = varid), &
                op_name = "nf90_inq_varid" &
                )
        call check_error(&
                nf90_inquire_variable(ncid = ncid, varid = varid, dimids = dimids), &
                op_name = "nf90_inquire_variable" &
                )
        call check_error(&
                nf90_inquire_dimension(ncid = ncid, dimid = dimids(1), len = len), &
                op_name = "nf90_inquire_dimension" &
                )
        allocate(value(len))
        call check_error(&
                nf90_get_var(ncid = ncid, varid = varid, values = value), &
                op_name = "nf90_get_var" &
                )
    end function get_real_array_variable
end module netcdf_utils_module