defmodule Supervise.MaxRestarts.SuperviseOneForOne do
  use Supervisor

  import Supervise.Utils.Process

  alias Supervise.Workers.SimpleWorker

  @child_names [
    :max_restarts_worker1,
    :max_restarts_worker2,
    :max_retarts_worker3,
    :max_restarts_worker4
  ]

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
  end

  @impl true
  def init(:ok) do
    IO.puts("#{__MODULE__} is starting")
    children = Enum.map(@child_names, &SimpleWorker.build_spec(&1))
    opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
    Supervisor.init(children, opts)
  end

  def test_kill_all do
    IO.puts("Before kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")
    Enum.each(@child_names, fn process_name -> stop_process(process_name) end)
    Process.sleep(500)
    IO.puts("After kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")
  end

  def test_kill_three do
    IO.puts("Before kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")

    @child_names
    |> Enum.take(3)
    |> Enum.each(fn process_name -> stop_process(process_name) end)

    Process.sleep(500)
    IO.puts("After kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")
  end

  def children do
    children(__MODULE__)
  end
end
