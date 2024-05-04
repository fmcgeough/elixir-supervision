defmodule Supervise.RestartTypes.Temporary do
  use Supervisor

  import Supervise.Utils.Process

  alias Supervise.Workers.SimpleWorker

  @child_names [
    :restart_temporary_worker1,
    :restart_temporary_worker2,
    :restart_temporary_worker3
  ]

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts("#{__MODULE__} is starting")

    children = Enum.map(@child_names, &SimpleWorker.build_spec(&1, :temporary))

    opts = [
      strategy: :one_for_one,
      max_restarts: 3,
      max_seconds: 5,
      max_children: 10
    ]

    Supervisor.init(children, opts)
  end

  def test_kill_all(order \\ :asc) when order in [:asc, :desc] do
    order
    |> case do
      :asc -> @child_names
      :desc -> Enum.reverse(@child_names)
    end
    |> Enum.each(&test_kill_one_process(&1))
  end

  def test_kill_one_process(process_name) when process_name in @child_names do
    kill_process(__MODULE__, process_name)
  end

  def test_kill_one_process(process_name) do
    IO.puts("Invalid process name. #{inspect(process_name)} is not in the list of child names")
  end

  def children do
    children(__MODULE__)
  end
end
