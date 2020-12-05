Code.require_file("BoardingPass.ex")

answer = BoardingPass.get_seats |> Enum.max
IO.puts "Answer: #{answer}"
