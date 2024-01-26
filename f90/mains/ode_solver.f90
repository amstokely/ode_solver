program ode_solver
    use equations, only : set_initial_state, f
    use observer, only : observer_init, observer_finalize, observer_write
    use lorenz_system, only : x0, y0, z0
    use ode_system, only : system_size
    use euler, only : euler_step
    use rk, only: rk2
    implicit none

    character(len = 100) :: dt_arg, n_arg, output_file
    integer :: n
    real :: dt, t
    real, dimension(:), allocatable :: s
    procedure(f), pointer :: fn
    fn => f

    x0 = 10.0
    y0 = 0.0
    z0 = 10.0
    call get_command_argument(1, dt_arg)
    call get_command_argument(2, n_arg)
    call get_command_argument(3, output_file)
    read(dt_arg, *) dt
    read(n_arg, *) n
    system_size = 3
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

