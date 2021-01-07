package advent;

import java.util.Locale;

public class Direction {

    public enum Cardinal {
        NORTH,
        EAST,
        SOUTH,
        WEST;

        public static Cardinal FromString(String s) {
            char c = s.toUpperCase().charAt(0);
            switch (c) {
                case 'N': return NORTH;
                case 'E': return EAST;
                case 'S': return SOUTH;
                case 'W': return WEST;
                default: throw new IllegalArgumentException("Invalid input " + s);
            }
        }

        public Cardinal nextClockwise() {
            switch (this) {
                case NORTH: return EAST;
                case EAST: return SOUTH;
                case SOUTH: return WEST;
                case WEST: return NORTH;
            }

            return null;
        }

        public Cardinal prevClockwise() {
            switch (this) {
                case NORTH: return WEST;
                case EAST: return NORTH;
                case SOUTH: return EAST;
                case WEST: return SOUTH;
            }

            return null;
        }

        public String toString() {
            switch (this) {
                case NORTH: return "N";
                case EAST: return "E";
                case SOUTH: return "S";
                case WEST: return "W";
            }

            return null;
        }
    }

    public enum Axis {
        NORTH_SOUTH,
        EAST_WEST;

        public Cardinal getCardinal(int value) {
            if (this == NORTH_SOUTH) {
                return (value >= 0) ? Cardinal.NORTH : Cardinal.SOUTH;
            } else {
                return (value >= 0) ? Cardinal.EAST : Cardinal.WEST;
            }
        }
    }

    private Axis axis;
    private int value;

    public Direction(Cardinal cardinal, int value) {
        if (cardinal == Cardinal.EAST || cardinal == Cardinal.WEST) {
            this.axis = Axis.EAST_WEST;
        } else {
            this.axis = Axis.NORTH_SOUTH;
        }

        this.value = (cardinal == Cardinal.SOUTH || cardinal == Cardinal.WEST) ? value * -1 : value;
    }

    public Direction(String input) {
        this(Cardinal.FromString(input), Integer.parseInt(input.substring(1)));
    }

    private Cardinal getCardinal() {
        return this.axis.getCardinal(this.value);
    }

    public int getValue() {
        return value;
    }

    public int getAbsoluteValue() {
        return Math.abs(value);
    }

    public void plus(Direction d) {
        this.value += d.value;
    }

    public String toString() {
        return String.format("%s %s", this.axis.getCardinal(this.value), this.getAbsoluteValue());
    }
}
