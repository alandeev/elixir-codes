defmodule Recursion do
  def forEach(list, fun) do
    Recursion.forEach(list, fun, 0)
  end

  def forEach(list, fun, index) do
    if index < length(list) do
      item = Enum.at(list, index)
      fun.(item, index)

      Recursion.forEach(list, fun, index + 1)
    else
      :ok
    end
  end

  # def forEach(_, _, _) do
  #   :ok
  # end

  def acumulator([head | tail], total) do
    if head >= 2 do
      IO.puts(head)
    end

    Recursion.acumulator(tail, head + total)
  end

  def acumulator([], total) do
    total
  end
end

total = Recursion.acumulator([1, 2, 3], 0)
IO.puts(total)

# Recursion.forEach([1, 2, 3], fn item, index ->
#   IO.puts("index: #{index} -> item: #{item}")
# end)
