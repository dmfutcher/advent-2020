module bootmachine
    implicit none

    type operation
        character(len=3) opcode
        integer val
    end type
contains

    function parse_op(line) result(op)
        character(len=*) :: line
        character(len=3) :: opcode
        character(len=:), allocatable :: val_str
        character(len=1) :: val_sign
        type(operation) :: op
        integer :: line_len, val

        line_len = len(line)
        opcode = line(1:3)
        val_sign = line(5:6)
        val_str = line(6:line_len)

        read(val_str, *) val
        if (val_sign == '-') then
            val = val * (-1)
        endif

        op%opcode = opcode
        op%val = val
    end function

    function load_program(fname) result(prog)
        character (len=*) :: fname
        character(len=200) :: line
        type(operation), allocatable :: prog(:)
        integer :: line_count, io_result, i
        integer :: fd = 9

        open(fd, file=fname, status="old")
        
        line_count = 0
        do
            read(fd, '(A)', iostat=io_result) line
            if (io_result /= 0) exit
            line_count = line_count + 1
        end do

        
        allocate(prog(line_count))
        rewind(fd)

        do i = 1, line_count
            read(fd, '(A)') line
            prog(i) = parse_op(trim(line))
            print *, prog(i)
        end do

        close(fd)
    end function

end module bootmachine

program part1
    use bootmachine
    type(operation), allocatable :: prog(:)
    
    prog = load_program("input")
end program