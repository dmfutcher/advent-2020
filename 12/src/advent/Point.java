package advent;

public class Point {
    public Direction ew;
    public Direction ns;

    public Point() {
        this.ew = new Direction(Direction.Cardinal.EAST, 0);
        this.ns = new Direction(Direction.Cardinal.NORTH, 0);
    }

    public Point(Direction ns, Direction ew) {
        this.ew = ew;
        this.ns = ns;
    }

    public String toString() {
        return String.format("%s %s", this.ns, this.ew);
    }

}
