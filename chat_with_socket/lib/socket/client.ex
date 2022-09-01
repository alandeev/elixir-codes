defmodule Socket.Client do
  use GenServer

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state \\ %{}) do
    IO.inspect("Starting Client")
    {:ok, state}
  end

  def handle_info({:tcp, socket, message}, clients) do
    # result = String.trim_trailing(message) - learning
    #   |> (&Map.get(clients, &1)).()

    name = String.trim_trailing(message)

    case Map.get(clients, name) do
      nil ->
        chatPid = Process.whereis(Socket.Chat)
        send(chatPid, {:client_register, name, socket})
        :gen_tcp.controlling_process(socket, chatPid)
        {:noreply, Map.put(clients, name, socket)}
      _ ->
        :gen_tcp.send(socket, "\nEscolha um nome diferente: ")
        {:noreply, clients}
    end
  end
end
