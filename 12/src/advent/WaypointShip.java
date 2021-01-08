package advent;

public class WaypointShip extends Ship {

    private Point waypoint;

    public WaypointShip(Point waypoint) {
        super();

        this.waypoint = waypoint;
    }

    private void rotateWaypointClockwise() {
        int nsVal = waypoint.ns.getValue();
        waypoint.ns.setValue(-waypoint.ew.getValue());
        waypoint.ew.setValue(nsVal);
    }

    private void rotateWaypointAntiClockwise() {
        int nsVal = waypoint.ns.getValue();
        waypoint.ns.setValue(waypoint.ew.getValue());
        waypoint.ew.setValue(-nsVal);
    }

    @Override
    public void performInstruction(String instruction) {
        char opcode = instruction.charAt(0);

        switch (opcode) {
            case 'N':
            case 'S':
                this.waypoint.ns.plus(new Direction(instruction));
                return;
            case 'E':
            case 'W':
                this.waypoint.ew.plus(new Direction(instruction));
                return;
            case 'L':
            case 'R':
                int rotations = Integer.parseInt(instruction.substring(1)) / 90;
                for (int i = 0; i < rotations; i++) {
                    if (opcode == 'R') {
                        rotateWaypointClockwise();
                    } else {
                        rotateWaypointAntiClockwise();
                    }
                }
                return;
            case 'F':
                int distance = Integer.parseInt(instruction.substring(1));
                for (int i = 0; i < distance; i++) {
                    this.location.ew.plus(this.waypoint.ew);
                    this.location.ns.plus(this.waypoint.ns);
                }
                return;
        }
    }

    public String toString() {
        return String.format("Ship is at (%s), waypoint (%s)", this.location, this.waypoint);
    }
}
