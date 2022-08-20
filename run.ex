current_pid = self()
IO.puts("processo atual: #{inspect(current_pid)}")

receiver_id =
  spawn(fn ->
    receive do
      {_, _} -> IO.puts("Processo do spawn: #{inspect(self())}")
    end
  end)

send(receiver_id, {:awdaw, "qualquer coisa"})
