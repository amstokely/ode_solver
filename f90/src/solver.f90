module solver_module

    private :: s
    real, allocatable :: s(:)

contains
    subroutine init()
        use equations, only : get_system_size, set_initial_state
        use observer, only : observer_init
        use integrator_module, only: integrator_init, integrator
        use system_module, only: system_init
        implicit none
        integer :: system_size

        call system_init()
        system_size = get_system_size()
        call set_initial_state(s)
        call integrator_init()
        call observer_init()
    end subroutine init

    subroutine solve()
        use integrator_module, only: integrator
        use observer, only : observer_finalize
        implicit none
        real :: t
        t = 0.0
        call integrator(t, s)
        call observer_finalize()
        deallocate(s)
    end subroutine solve
end module solver_module