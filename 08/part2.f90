
module program_fixer
    use bootmachine
    implicit none
contains

    function jmp_nop_indices(prog) result(indices)
        type(operation) :: prog(:)
        integer, allocatable :: indices(:)
        integer :: count, op_n, prog_len, index

        prog_len = ubound(prog, 1)
        count = 0
        do op_n = 1, prog_len
            if (prog(op_n)%opcode == "jmp" .or. prog(op_n)%opcode == "nop") then
                count = count + 1
            endif
        end do

        allocate(indices(count))

        index = 1
        do op_n = 1, prog_len
            if (prog(op_n)%opcode == "jmp" .or. prog(op_n)%opcode == "nop") then
                indices(index) = op_n
                index = index + 1
            endif
        end do
    end function

    function modify_program(prog, op_index) result(mod_prog)
        type(operation) :: prog(:), op
        type(operation), allocatable :: mod_prog(:)
        integer :: op_index

        mod_prog = prog
        op = prog(op_index)

        if (op%opcode == "jmp") then
            op%opcode = "nop"
        else
            op%opcode = "jmp"
        endif

        mod_prog(op_index) = op
    end function

    function find_fixed_program(prog) result(result_acc)
        type(operation) :: prog(:)
        type(operation), allocatable :: mod_prog(:)
        type(exec_ctx) :: exec_result
        integer :: result_acc, i_op
        integer, allocatable :: ops(:)

        ops = jmp_nop_indices(prog)

        do i_op = 1, ubound(ops, 1)
            mod_prog = modify_program(prog, ops(i_op))
            exec_result = execute_program(mod_prog)

            if (exec_result%halt == 1) then
                result_acc = exec_result%acc
                return
            endif
        end do
    end function

end module

program part2
    use bootmachine
    use program_fixer

    type(operation), allocatable :: prog(:)
    integer :: result
    
    prog = load_program("input")
    result = find_fixed_program(prog)
    print *, "Answer: ", result
end program
