defmodule PubSub do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:publish, topic, message} ->
        IO.puts("topico: #{topic}")

        workerList = Map.get(map, :"#{topic}")
        Enum.map(workerList, fn worker -> send(worker, {:"#{topic}", message}) end)

        loop(map)

      {:add, topic, newWorker} ->
        case Map.get(map, :"#{topic}") do
          nil ->
            loop(Map.put(map, :"#{topic}", [newWorker]))

          workers ->
            listAllWorkers = List.flatten([workers] ++ [newWorker])
            loop(Map.put(map, :"#{topic}", listAllWorkers))
        end
    end
  end
end

w1 =
  spawn(fn ->
    receive do
      {:create, msg} ->
        IO.puts("Usuario criado: w1 #{inspect(msg)}")
        IO.puts(msg)
    end
  end)

w2 =
  spawn(fn ->
    receive do
      {:create, msg} ->
        IO.puts("Usuario criado: w2 #{inspect(msg)}")
        IO.puts(msg)

      {:delete, msg} ->
        IO.puts("Usuario deletado: w2 #{inspect(msg)}")
        IO.puts(msg)
    end
  end)

{:ok, pubSubPid} = PubSub.start_link()

send(pubSubPid, {:add, "create", w1})
send(pubSubPid, {:add, "create", w2})
send(pubSubPid, {:add, "delete", w2})

send(pubSubPid, {:publish, "create", "alandev"})
