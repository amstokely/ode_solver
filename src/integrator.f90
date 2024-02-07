module abstract_integrator_module
    implicit none
    abstract interface
        subroutine abstract_integrator(t, s)
            implicit none
            real, intent(inout) :: t
            real, dimension(:), intent(inout) :: s
        end subroutine abstract_integrator
    end interface
end module abstract_integrator_module

module integrator_module
    use abstract_integrator_module, only : abstract_integrator
    implicit none

    public :: integrator, integrator_init
    private :: integrator_name

    character(len = 256) :: integrator_name

    procedure(abstract_integrator), pointer :: integrator

contains
    subroutine integrator_init()
        use euler_integrator_module, only : euler_integrator
        use rk_integrator_module, only : rk2_integrator
        use settings_module, only : integrator_name
        implicit none

        if (trim(integrator_name) == 'rk2') then
            integrator => rk2_integrator
        else if (trim(integrator_name) == 'euler') then
            integrator => euler_integrator
        end if
    end subroutine integrator_init


end module integrator_module