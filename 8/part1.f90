module bootmachine
    implicit none

    type operation
        character(len=3) :: opcode
        integer :: val
    end type

    type exec_ctx
        integer :: pc, acc, halt, prog_len
        integer, allocatable :: call_map(:)
    end type
contains

    function parse_op(line) result(op)
        character(len=*) :: line
        type(operation) :: op
    
        character(len=3) :: opcode
        character(len=:), allocatable :: val_str
        character(len=1) :: val_sign
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
        character(len=*) :: fname
        type(operation), allocatable :: prog(:)

        character(len=200) :: line
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
        end do

        close(fd)
    end function

    function new_execution_context(prog_len) result(ctx)
        integer :: prog_len, i
        type(exec_ctx) ctx

        ctx%acc = 0
        ctx%pc = 1
        ctx%halt = 0
        ctx%prog_len = prog_len
        allocate(ctx%call_map(prog_len))

        do i = 1, prog_len
            ctx%call_map(i) = 0
        end do
    end function

    subroutine execute_operation(op, ctx)
        type(operation) :: op
        type(exec_ctx) :: ctx

        if (ctx%call_map(ctx%pc) /= 0) then
            ctx%halt = 1
            return
        else
            ctx%call_map(ctx%pc) = ctx%call_map(ctx%pc) + 1
        endif

        if (op%opcode == "acc") then
            ctx%acc = ctx%acc + op%val
            ctx%pc = ctx%pc + 1
        else if (op%opcode == "jmp") then
            ctx%pc = ctx%pc + op%val
        else if (op%opcode == "nop") then
            ctx%pc = ctx%pc + 1
        endif
    end subroutine

    function execute_program(prog) result(final_acc)
        type(operation) :: prog(:), current_op
        integer :: final_acc
        type(exec_ctx) :: context

        context = new_execution_context(ubound(prog, 1))
        do 
            current_op = prog(context%pc)
            call execute_operation(current_op, context)
 
            if (context%halt /= 0) then
                exit
            endif
        end do

        final_acc = context%acc
    end function

end module bootmachine

program part1
    use bootmachine
    type(operation), allocatable :: prog(:)
    integer :: result
    
    prog = load_program("input")
    result = execute_program(prog)
    print *, "Answer: ", result
end program