sum = fn x, y -> x + y end

list = Enum.map(1..3, &sum.(&1, 3))
list |> IO.inspect()
