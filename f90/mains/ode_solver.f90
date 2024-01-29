program ode_solver
    use equations, only : set_initial_state, f
    use observer, only : observer_init, observer_finalize, observer_write
    use lorenz_system, only : x0, y0, z0, lorenz, &
            set_x0, set_y0, set_z0, set_sigma, &
            set_rho, set_beta, sigma, rho, beta
    use ode_system, only : system_size, system
    use command_line_setters
    use euler, only : euler_step
    use rk, only: rk2
    implicit none

    character(len = 100) :: dt_arg, n_arg, output_file, &
            x0_arg, y0_arg, z0_arg, &
            sigma_arg, rho_arg, beta_arg
    integer :: n
    real :: dt, t
    real, dimension(:), allocatable :: s
    procedure(f), pointer :: fn
    !
    allocate(setters(6))
    setters(1)%ptr => set_x0
    setters(2)%ptr => set_y0
    setters(3)%ptr => set_z0
    setters(4)%ptr => set_sigma
    setters(5)%ptr => set_rho
    setters(6)%ptr => set_beta
    fn => f


    ! TODO: Add this behavior to a seperate module that will generically parse and set parameters from the command line
    x0_arg = "10.0"
    y0_arg = "0.0"
    z0_arg = "10.0"
    sigma_arg = "10.0"
    rho_arg = "28.0"
    beta_arg = "2.66667"
    call setters(1)%ptr(x0_arg)
    call setters(2)%ptr(y0_arg)
    call setters(3)%ptr(z0_arg)
    call setters(4)%ptr(sigma_arg)
    call setters(5)%ptr(rho_arg)
    call setters(6)%ptr(beta_arg)
    call get_command_argument(1, dt_arg)
    call get_command_argument(2, n_arg)
    call get_command_argument(3, output_file)
    read(dt_arg, *) dt
    read(n_arg, *) n
    system_size = 3
    system => lorenz
    call set_initial_state(s)
    t = 0.0
    call observer_init(output_file)

    do while (t < n)
        s = rk2(t, s, dt, fn)
        t = t + dt
        call observer_write(s)
    end do

    call observer_finalize()

end program ode_solver

