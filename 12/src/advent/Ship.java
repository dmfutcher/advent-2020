package advent;

public class Ship {

    private Direction ew;
    private Direction ns;
    private Direction.Cardinal heading;

    public Ship() {
        this.ew = new Direction(Direction.Cardinal.EAST, 0);
        this.ns = new Direction(Direction.Cardinal.NORTH, 0);
        this.heading = Direction.Cardinal.EAST;
    }

    public int distanceFromOrigin() {
        return this.ew.getAbsoluteValue() + this.ns.getAbsoluteValue();
    }

    public void performInstruction(String instruction) {
        char opcode = instruction.charAt(0);

        switch (opcode) {
            case 'N':
            case 'S':
                this.ns.plus(new Direction(instruction));
                return;
            case 'E':
            case 'W':
                this.ew.plus(new Direction(instruction));
                return;
            case 'L':
            case 'R':
                int rotations = Integer.parseInt(instruction.substring(1)) / 90;
                for (int i = 0; i < rotations; i++) {
                    if (opcode == 'R') {
                        this.heading = this.heading.nextClockwise();
                    } else {
                        this.heading = this.heading.prevClockwise();
                    }
                }
                return;
            case 'F':
                if (this.heading == Direction.Cardinal.NORTH || this.heading == Direction.Cardinal.SOUTH) {
                    this.ns.plus(new Direction(this.heading.toString() + instruction.substring(1)));
                } else {
                    this.ew.plus(new Direction(this.heading.toString() + instruction.substring(1)));
                }
        }
    }

    public String toString() {
        return String.format("Ship is at %s, %s, facing %s", this.ew, this.ns, this.heading);
    }

}
