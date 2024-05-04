defmodule Supervise.Types.SuperviseDynamically do
  use DynamicSupervisor

  alias Supervise.Workers.SimpleWorker

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
  end

  def add_worker(name, data) do
    spec = SimpleWorker.build_spec(name, data)
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(:ok) do
    IO.puts("#{__MODULE__} is starting")

    opts = [
      strategy: :one_for_one,
      max_restarts: 3,
      max_seconds: 5,
      max_children: 10,
      extra_arguments: []
    ]

    DynamicSupervisor.init(opts)
  end

  def start_worker(name, restart_type \\ :permanent) do
    spec = SimpleWorker.build_spec(name, restart_type)
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
