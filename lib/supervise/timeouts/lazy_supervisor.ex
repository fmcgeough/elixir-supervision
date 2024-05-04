defmodule Supervise.Timeouts.LazySupervisor do
  use Supervisor

  alias Supervise.Timeouts.Lazy

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts("#{__MODULE__} is starting")

    children = [
      lazy_spec(name: :lazy_start_link, start_link_delay: 1_000),
      lazy_spec(name: :lazy_init, init_delay: 1_000)
    ]

    opts = [
      strategy: :one_for_one,
      max_restarts: 3,
      max_seconds: 5,
      max_children: 10
    ]

    Supervisor.init(children, opts)
  end

  defp lazy_spec(opts) do
    name = Keyword.get(opts, :name)

    %{
      id: name,
      start: {Lazy, :start_link, [opts]},
      restart: :permanent,
      type: :supervisor
    }
  end
end
