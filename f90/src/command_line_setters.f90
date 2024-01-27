module command_line_setters
    abstract interface
        subroutine setter(arg)
            character(len = 100), intent(in) :: arg
        end subroutine setter
    end interface
    type setter_ptr
        procedure(setter), pointer, nopass :: ptr
    end type setter_ptr
    type(setter_ptr), allocatable :: setters(:)
    character(len = 100), allocatable :: variable_names(:)
end module command_line_setters