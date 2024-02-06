module netcdf_utils_module
contains

    integer function get_integer_variable(ncid, name)
        use netcdf
        implicit none
        integer, intent(in) :: ncid
        character(len = *), intent(in) :: name
        integer :: varid, status
        integer :: value
        status = nf90_inq_varid(ncid, name, varid)
        status = nf90_get_var(ncid, varid, value)
        get_integer_variable = value
    end function get_integer_variable

    real function get_real_variable(ncid, name)
        use netcdf
        implicit none
        integer, intent(in) :: ncid
        character(len = *), intent(in) :: name
        integer :: varid, status
        real :: value
        status = nf90_inq_varid(ncid, name, varid)
        status = nf90_get_var(ncid, varid, value)
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
        status = nf90_inq_varid(ncid, name, varid)
        status = nf90_inquire_variable(&
                ncid = ncid, &
                varid = varid, &
                dimids = dimids &
                )
        status = nf90_inquire_dimension(&
                ncid = ncid, &
                dimid = dimids(1), &
                len = len &
                )
        allocate(value(len))
        status = nf90_get_var(ncid, varid, value)
    end function get_real_array_variable
end module netcdf_utils_module