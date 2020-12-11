program part1
    use bootmachine

    type(operation), allocatable :: prog(:)
    type(exec_ctx) :: result
    
    prog = load_program("input")
    result = execute_program(prog)
    print *, "Answer: ", result%acc
end program
