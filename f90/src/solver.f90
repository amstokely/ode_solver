module solver_module

    private :: s
    real, allocatable :: s(:)

contains
    subroutine init()
        use equations, only : set_initial_state
        use observer, only : observer_init
        use integrator_module, only: integrator_init
        use system_module, only: system_init
        use settings_module, only: read_settings
        implicit none
        call read_settings()
        call system_init()
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