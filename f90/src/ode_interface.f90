module ode_interface
    abstract interface
        function ode(s) result(y)
            real, dimension(:), intent(in) :: s
            real, dimension(size(s)) :: y
        end function ode
    end interface
end module ode_interface