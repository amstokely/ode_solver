module ode_system
    abstract interface
        function ode(t, s) result(y)
            real, intent(in) :: t
            real, dimension(:), intent(in) :: s
            real, dimension(size(s)) :: y
        end function ode
    end interface
    integer :: system_size

end module ode_system