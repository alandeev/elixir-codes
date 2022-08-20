defmodule Cache do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))
        loop(map)

      {:put, key, value} ->
        loop(Map.put(map, key, value))

      {:get_all, caller} ->
        send(caller, {map})
        loop(map)
    end
  end
end

worker =
  spawn(fn ->
    receive do
      {map} ->
        IO.puts(map[2])
    end
  end)

{:ok, pid} = Cache.start_link()

send(pid, {:put, 1, "alandev"})
send(pid, {:put, 2, "pedrodev"})
send(pid, {:get_all, worker})
