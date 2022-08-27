defmodule Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state}
  end

  # Chamanda sincrona para o processo
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  # Enviar mensagem diretamente para o servidor ( GenServer )
  def handle_cast({:rem, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  # Monitora mensagens do processo.
  def handle_info({:add, key, value}, state) do
    IO.puts("Olá mundo")
    {:noreply, Map.put(state, key, value)}
  end
end


{:ok, pid} = Server.start_link() # Starting server

send(pid, {:add, "name", "alan"}) # Sending message assync to Server

GenServer.call(pid, {:get, "name"}) # Sending Sync to get data from Server
  |> IO.inspect()

GenServer.cast(pid, {:rem, "name"}) # Sending assync to Server
