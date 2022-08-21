### Anotations

# Trailing question mark (foo?)
# Functions that return a boolean are named with a trailing question mark.

### Modules

defmodule Math do
  def zero?(0), do: true
  def zero?(x) when is_integer(x), do: false
  def zero?(x, y), do: x + y
end

funcZ = &Math.zero?(&1, 4)
result = funcZ.(50)
IO.puts("ACIMA: #{result}")

IO.puts(Math.zero?(0))
IO.puts(Math.zero?(1))
# IO.puts(Math.zero?([1, 2, 3]))
# IO.puts(Math.zero?(0.0))

### Functions Capturing

fun = &Math.zero?/1
IO.puts(is_function(fun))
IO.puts(fun.(0))

(&is_function/1).(fun)

# capturing operators
add = &+/2
IO.puts(add.(1, 2))

# capturing arguments
inc = &(&1 + 1)
IO.puts(inc.(4))

concact = &"Good #{&1}"
IO.puts(concact.("morning"))

### Default Arguments

# If a function with default values has multiple clauses,
# it is required to create a function head (a function definition without a body)
# for declaring defaults:
defmodule Concat do
  # A function head declaring defaults
  def join(a, b \\ nil, sep \\ " ")

  def join(a, b, _sep) when is_nil(b),
    do: a

  def join(a, b, sep) do
    a <> sep <> b
  end

  def hello(x \\ "default-value"),
    do: x
end

IO.puts(Concat.join("Hello", "world"))
IO.puts(Concat.join("Hello", "world", "_"))
IO.puts(Concat.join("Hello"))
IO.puts(Concat.hello())
IO.puts(Concat.hello("Other value"))
