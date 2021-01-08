import java.io.File

enum class Operation {
    Mask, Store
}

data class Instruction(val op: Operation, val source: String, val destination: String? = null)

class DockingComputer {

    var memory = HashMap<Int, String>()
    var mask: String? = null

    fun runProgram(program: List<Instruction>) {
        for (instruction in program) {
            if (instruction.op == Operation.Mask) {
                execMask(instruction.source)
            } else if (instruction.op == Operation.Store) {
                if (instruction.destination == null) continue
                execStore(instruction.destination.toInt(), instruction.source.toInt())
            }
        }
    }

    fun execMask(newMask: String) {
        this.mask = newMask;
    }

    fun execStore(address: Int, value: Int) {
        val valBin = value.toString(2).padStart(36, '0')
        var result = StringBuilder()
        
        for ((i, bit) in valBin.withIndex()) {
            val maskBit = this.mask?.get(i);

            if (maskBit == 'X') {
                result.append(bit)
            } else {
                result.append(maskBit)
            }
        }

        this.memory[address] = result.toString()
    }

}

fun parseInstruction(instruction: String): Instruction {
    val parts = instruction.split(" = ")

    if (parts[0].startsWith("mask")) {
        return Instruction(Operation.Mask, parts[1])
    } else {
        val destination = parts[0].substring((parts[0].indexOf('[') + 1)..(parts[0].indexOf(']') - 1));
        return Instruction(Operation.Store, parts[1], destination)
    }
}

fun main() {
    val program =  File("input").useLines { it.toList().map{ parseInstruction(it) } }
    val computer = DockingComputer()
    computer.runProgram(program)

    println(computer.memory.values.map { it.toLong(2) }.sum())
}