with open("input") as f:
    lines = [int(l.strip()) for l in f.readlines()]

for x in lines:
    for y in lines:
        if x + y == 2020:
            print(f"{x} + {y} == 2020")
            print(f"Answer: {x * y}")
