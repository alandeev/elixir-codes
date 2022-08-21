defmodule PubSub do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:publish, topic, message} ->
        IO.puts("New message in topic: #{topic}")

        workerList = Map.get(map, topic)
        Enum.map(workerList, fn worker -> send(worker, {topic, message}) end)

        loop(map)

      {:add, topic, newWorker} ->
        workers = Map.get(map, topic)

        if workers != nil,
          do: loop(Map.put(map, topic, List.flatten(workers ++ [newWorker]))),
          else: loop(Map.put(map, topic, [newWorker]))
    end
  end
end

w1 =
  spawn(fn ->
    receive do
      {:create, msg} ->
        IO.puts("User created: w1 #{inspect(msg)}")
        IO.puts(msg)
    end
  end)

w2 =
  spawn(fn ->
    receive do
      {:create, msg} ->
        IO.puts("User created: w2 #{inspect(msg)}")
        IO.puts(msg)

      {:delete, msg} ->
        IO.puts("User deleted: w2 #{inspect(msg)}")
        IO.puts(msg)
    end
  end)

{:ok, pubSubPid} = PubSub.start_link()

send(pubSubPid, {:add, :create, w1})
send(pubSubPid, {:add, :create, w2})
send(pubSubPid, {:add, :delete, w2})

send(pubSubPid, {:publish, :create, "alandev"})
