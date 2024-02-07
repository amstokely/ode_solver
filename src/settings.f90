module settings_module
    implicit none
    public :: system_name, params, output_file, n, integrator_name, dt
    character(len=256) :: system_name, params, output_file, integrator_name
    integer :: n
    real :: dt
    namelist /settings/ system_name, params, output_file, n, integrator_name, dt
    contains
    subroutine read_settings()
        implicit none
        integer :: io_status
        character(len=256) :: namelist_file
        call get_command_argument(1, namelist_file)
        open(10, file=trim(namelist_file), status='old', action='read', iostat=io_status)
        read(10, nml=settings, iostat=io_status)
        close(10)
    end subroutine read_settings
end module settings_module