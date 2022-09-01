client_register = spawn(fn ->
  receive do
    {:tcp, _, data} ->
      IO.puts(data)
  end
end)

{:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: :raw, active: true, reuseaddr: true])



client_register
