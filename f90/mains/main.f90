program ode_solver
    use parameters, only: dt, n, sigma, beta, rho, x0, y0, z0, state_size, output_file
    use equations, only: set_initial_state, f
    use observer, only: observer_init, observer_finalize, observer_write
    implicit none

    character(len = 100) :: dt_arg, n_arg
    real :: s(3), t


    call GET_COMMAND_ARGUMENT(1, dt_arg)
    call GET_COMMAND_ARGUMENT(2, n_arg)
    call GET_COMMAND_ARGUMENT(3, output_file)
    read(dt_arg, *) dt
    read(n_arg, *) n
    x0 = 1.0
    y0 = 1.0
    z0 = 1.0
    state_size = 3
    t=0.0
    call observer_init()

    call set_initial_state(s)
    do while (t < n)
        s = f(t, s)
        t = t + dt
        call observer_write(s)
    end do

    call observer_finalize()


end program ode_solver

