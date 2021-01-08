import java.io.File
import java.math.BigInteger

enum class Operation {
    Mask, Store 
}

data class Instruction(val op: Operation, val source: String, val destination: String? = null)

open class DockingComputer {

    var memory = HashMap<BigInteger, String>()
    var mask: String = ""

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

    open fun execStore(address: Int, value: Int) {
        val valBin = this.numToBin(value)
        var result = StringBuilder()
        
        for ((i, bit) in valBin.withIndex()) {
            val maskBit = this.mask.get(i);

            if (maskBit == 'X') {
                result.append(bit)
            } else {
                result.append(maskBit)
            }
        }

        this.memory[address.toBigInteger()] = result.toString()
    }

    fun binToNum(b: String) = BigInteger(b, 2)
    fun numToBin(n: Int) = n.toString(2).padStart(36, '0')

}

class DockingComputerV2 : DockingComputer() {

    override fun execStore(address: Int, value: Int) {
        var floatingIndices: MutableList<Int> = mutableListOf();

        for ((i, bit) in this.mask.withIndex()) {
            if (bit == 'X') {
                floatingIndices.add(i)
            }
        }

        val addresses = translatedAddresses(address, floatingIndices)
        for (addr in addresses) {
            this.memory[this.binToNum(addr)] = this.numToBin(value)
        }
    }

    fun translatedAddresses(address: Int, floatingIndices: List<Int>): List<String> {
        var addresses = mutableListOf<String>()
        val addrBin = this.numToBin(address)

        val sets = mutableListOf<Set<Char>>().apply {
            repeat(floatingIndices.size){ this.add(index = it, element = setOf('1', '0')) }
        }
        val perms = sets.getCartesianProduct()

        val maskedAddr = StringBuilder()
        
        for ((i, bit) in this.mask.withIndex()) {
            if (bit == '1') {
                maskedAddr.append("1")
            } else if (bit == '0') {
                maskedAddr.append(addrBin[i])
            } else {
                maskedAddr.append('X')
            }
        }

        for (permutation in perms) {
            var addr = StringBuilder(maskedAddr)
            for ((i, float) in floatingIndices.withIndex()) {
                addr.set(float, permutation[i])
            }

            addresses.add(addr.toString())
        }

        return addresses;
    }

}

fun <T> Collection<Iterable<T>>.getCartesianProduct(): Set<List<T>> =
    if (isEmpty()) emptySet()
    else drop(1).fold(first().map(::listOf)) { acc, iterable ->
        acc.flatMap { list -> iterable.map(list::plus) }
    }.toSet()

fun parseInstruction(instruction: String): Instruction {
    val parts = instruction.split(" = ")

    if (parts[0].startsWith("mask")) {
        return Instruction(Operation.Mask, parts[1])
    } else {
        val destination = parts[0].substring((parts[0].indexOf('[') + 1)..(parts[0].indexOf(']') - 1));
        return Instruction(Operation.Store, parts[1], destination)
    }
}

fun partOne(program: List<Instruction>) {
    val computer = DockingComputer()
    computer.runProgram(program)

    print("Part one: ")
    println(computer.memory.values.map { it.toLong(2) }.sum())
}

fun partTwo(program: List<Instruction>) {
    val computer = DockingComputerV2()
    computer.runProgram(program)

    print("Part two: ")
    println(computer.memory.values.map { it.toLong(2) }.sum())
}

fun main() {
    val program =  File("input").useLines { it.toList().map{ parseInstruction(it) } }
    partOne(program)
    partTwo(program)
}