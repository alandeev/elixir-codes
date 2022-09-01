defmodule Socket.Chat do
  use GenServer

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    IO.inspect("Starting Chat")
    {:ok, state}
  end

  def handle_info({:client_register, name, socket}, state) do
    send(socket, "Server", "Seja bem vindo ao servidor!")
    broadcast(state, "Server", "Usuário #{name} entrou no chat!")

    {:noreply, Map.put(state, socket, name)}
  end

  def handle_info({:tcp, socket, message}, state) do
    name = Map.get(state, socket)
    broadcast(state, name, message)

    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    name = Map.get(state, socket)
    newState = Map.delete(state, socket)
    broadcast(newState, "Server", "Usuário #{name} se desconectou")
    {:noreply, newState}
  end

  defp send(socket, owner_name, message) do
    :gen_tcp.send(socket, "#{owner_name}: #{message}")
  end

  defp broadcast(sockets, owner_name, message) do
    Enum.each(sockets, fn {socket, _} ->
      :gen_tcp.send(socket, "\n#{owner_name}: #{message}")
    end)
  end
end
