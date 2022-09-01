defmodule Socket.Application do
  use Application

  def start(_, _) do
    children = [
      {Socket.Client, [start: :start_link, name: Socket.Client]},
      {Socket.Chat, [start: :start_link, name: Socket.Chat]},
      {Socket.Server, [start: :start_link, name: Socket.Server ]}
    ]

    opts = [strategy: :one_for_one, name: Socket.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
