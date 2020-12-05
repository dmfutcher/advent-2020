Code.require_file("BoardingPass.ex")

seat_ids = BoardingPass.get_seats
range = Enum.min(seat_ids) .. Enum.max(seat_ids)

[{n, _} | _] = Enum.map(range, &({&1, &1 in seat_ids}))
                |> Enum.filter(fn {_, x} -> not x end)
IO.puts "Seat #{n}"
