package advent;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Main {

    private static Stream<String> getInput() throws IOException {
        return Files.lines(Paths.get("input"));
    }

    private static void partOne() {
        Ship ship = new Ship();
        Stream<String> input;

        try {
            input = getInput();
        } catch (IOException e) {
            System.err.println("Failed " + e);
            return;
        }

        input.forEach(i -> ship.performInstruction(i));
        System.out.println(ship.toString());

        System.out.println("Part One: " + ship.distanceFromOrigin());
    }

    public static void main(String[] args) {
        partOne();
    }
}
