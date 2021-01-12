import scala.io.Source
import fastparse._, SingleLineWhitespace._

sealed abstract class Expr()

object Expr {
  final case class Val(v: Int) extends Expr
  final case class Mul(e: Expr) extends Expr
  final case class Add(e: Expr) extends Expr
  final case class Group(initial: Expr, seq: Seq[Expr]) extends Expr
}

object Parser {
  def number[_: P]: P[Expr.Val] = P(CharIn("0-9").rep(1).!.map(_.toInt)).map(Expr.Val)
  def parens[_: P]: P[Expr.Group] = P("(" ~ math ~ ")")
  def value[_: P]: P[Expr] = P( number | parens )
  def mul[_: P]: P[Expr.Mul] = P("*" ~ value).map(Expr.Mul)
  def add[_: P]: P[Expr.Add] = P("+" ~ value).map(Expr.Add)
  def expr[_: P]: P[Expr] = P( mul | add )
  def math[_: P]: P[Expr.Group] = P( value ~ expr.rep()).map((v) => Expr.Group(v._1, v._2))

  def parse(in: String):Parsed[Expr.Group] = fastparse.parse(in, math(_))
}

object Main {

  def readInput: List[String] = {
    return Source.fromFile("input").getLines.toList
  }

  def calculate(g: Expr.Group): BigInt = {
    var total = BigInt(0)
    def eval(e: Expr): BigInt = {
      e match {
        case Expr.Val(n) => n
        case Expr.Add(e) => total + eval(e)
        case Expr.Mul(e) => total * eval(e)
        case g@Expr.Group(_, _) => calculate(g)
      }
    }

    total = eval(g.initial)
    for (seq_e <- g.seq.iterator) {
      total = eval(seq_e)
    }

    return total
  }

  def main(args: Array[String]): Unit = {
    val lines = readInput
    val parsed = lines.map(Parser.parse)

    val results = parsed.map(result =>
      result match {
        case Parsed.Success(e, _) => this.calculate(e)
        case Parsed.Failure(_, _, _) => throw new Exception("Failed to parse")
      })

    println(results)

    println("Part One: " + results.sum)
  }
}