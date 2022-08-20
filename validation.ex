defmodule Validation do
  def min(min_length) do
    &Validation.min(&1, min_length)
  end

  def min(val, min_length) when is_binary(val) do
    if String.length(val) >= min_length,
      do: val,
      else: {:error, "value must be min_length #{min_length}"}
  end

  def max(max_length) do
    &Validation.max(&1, max_length)
  end

  def max(val, max_length) when is_binary(val) do
    if String.length(val) <= max_length,
      do: val,
      else: {:error, "value must be max_length #{max_length}"}
  end
end

"alan12"
|> Validation.min(4)
|> Validation.max(6)
|> case do
  {:error, error} -> IO.puts("Error: #{error}")
  val -> IO.puts("Valor: #{val}")
end
