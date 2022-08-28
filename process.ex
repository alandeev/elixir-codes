# spawn and log error message
spawn(fn -> raise "oops" end)

# spawn, but it's linked with current process, and break too.
spawn_link(fn -> raise "ooops 2" end)

# While other languages would require us to catch/handle exceptions, in Elixir
# we are actually fine with letting processes fail because we expect supervisors
# to properly restart our systems. “Failing fast” (sometimes referred as “let it crash”)
# is a common philosophy when writing Elixir software!

# keep state using recursive function
defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end
