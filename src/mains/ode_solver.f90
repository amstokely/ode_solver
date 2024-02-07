program ode_solver
    use solver_module, only: init, solve
    implicit none
    call init()

    call solve()
end program ode_solver

