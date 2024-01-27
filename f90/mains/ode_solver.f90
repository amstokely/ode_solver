program ode_solver
    use equations, only : set_initial_state, f
    use observer, only : observer_init, observer_finalize, observer_write
    use lorenz_system, only : x0, y0, z0, lorenz, set_x0, set_y0, set_z0
    use ode_system, only : system_size, system
    use command_line_setters
    use euler, only : euler_step
    use rk, only: rk2
    implicit none

    character(len = 100) :: dt_arg, n_arg, output_file, x0_arg, y0_arg, z0_arg
    integer :: n
    real :: dt, t
    real, dimension(:), allocatable :: s
    procedure(f), pointer :: fn
    !
    type(setter_ptr), dimension(3) :: setters
    setters(1)%ptr => set_x0
    setters(2)%ptr => set_y0
    setters(3)%ptr => set_z0
    fn => f


    x0_arg = "10.0"
    y0_arg = "0.0"
    z0_arg = "10.0"
    call setters(1)%ptr(x0_arg)
    call setters(2)%ptr(y0_arg)
    call setters(3)%ptr(z0_arg)
    print *, "x0 = ", x0
    print *, "y0 = ", y0
    print *, "z0 = ", z0
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

