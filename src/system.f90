module abstract_system_module
    abstract interface
        function abstract_system(t, s) result(y)
            implicit none
            real, intent(in) :: t
            real, dimension(:), target, intent(in) :: s
            real, dimension(size(s)) :: y
        end function abstract_system

        subroutine abstract_system_initial_state(s)
            implicit none
            real, dimension(:), allocatable, intent(out) :: s
        end subroutine abstract_system_initial_state

    end interface
end module abstract_system_module

module system_module
    use abstract_system_module, only : abstract_system, abstract_system_initial_state
    implicit none

    public :: system, system_init, system_initial_state, system_size
    private :: system_name

    character(len = 256) :: system_name, params

    integer :: system_size
    procedure(abstract_system), pointer :: system
    procedure(abstract_system_initial_state), pointer :: system_initial_state

contains
    subroutine system_init()
        use lorenz_system_module, only : lorenz_system, &
                lorenz_init, &
                lorenz_system_initial_state, &
                lorenz_system_size
        use shallow_water_system_module, only : shallow_water_init, &
                shallow_water_system, &
                shallow_water_system_initial_state, &
                shallow_water_system_size
        use settings_module, only : system_name
        implicit none

        if (trim(system_name) == 'lorenz') then
            call lorenz_init()
            system => lorenz_system
            system_initial_state => lorenz_system_initial_state
            system_size = lorenz_system_size
        end if
        if (trim(system_name) == 'shallow_water') then
            call shallow_water_init()
            system => shallow_water_system
            system_initial_state => shallow_water_system_initial_state
            system_size = shallow_water_system_size
        end if
    end subroutine system_init

end module system_module
