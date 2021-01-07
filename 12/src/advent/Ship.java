package advent;

public class Ship {

    protected Point location;
    protected Direction.Cardinal heading;

    public Ship() {
        this.location = new Point();
        this.heading = Direction.Cardinal.EAST;
    }

    public int distanceFromOrigin() {
        return this.location.ew.getAbsoluteValue() + this.location.ns.getAbsoluteValue();
    }

    public void performInstruction(String instruction) {
        char opcode = instruction.charAt(0);

        switch (opcode) {
            case 'N':
            case 'S':
                this.location.ns.plus(new Direction(instruction));
                return;
            case 'E':
            case 'W':
                this.location.ew.plus(new Direction(instruction));
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
                    this.location.ns.plus(new Direction(this.heading.toString() + instruction.substring(1)));
                } else {
                    this.location.ew.plus(new Direction(this.heading.toString() + instruction.substring(1)));
                }
        }
    }

    public String toString() {
        return String.format("Ship is at (%s), facing %s", this.location, this.heading);
    }

}
