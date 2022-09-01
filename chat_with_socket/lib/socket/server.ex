defmodule Socket.Server do
  use GenServer

  def start_link(port \\ 1234) do
    GenServer.start_link(__MODULE__, 1234, name: __MODULE__)
  end

  def init(port) do
    IO.inspect("Starting Server")
    Task.start_link(fn -> server(port) end)
  end

  defp server(port) do
    {:ok, listenSocket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: true, reuseaddr: true])
    accept(listenSocket)
  end

  defp accept(socket) do
    case :gen_tcp.accept(socket) do
      {:ok, clientSocket} ->
        :gen_tcp.send(clientSocket, "\nDigite seu nome: ")
        :gen_tcp.controlling_process(clientSocket, Process.whereis(Socket.Client))
    end

    accept(socket)
  end
end
