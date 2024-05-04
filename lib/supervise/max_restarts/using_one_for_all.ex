defmodule Supervise.MaxRestarts.UsingOneForAll do
  use Supervisor

  import Supervise.Utils.Process

  alias Supervise.Workers.SimpleWorker

  @child_names [
    :max_restarts_one_for_all_worker1,
    :max_restarts_one_for_all_worker2,
    :max_restarts_one_for_all_worker3,
    :max_restarts_one_for_all_worker4,
    :max_restarts_one_for_all_worker5,
    :max_restarts_one_for_all_worker6,
    :max_restarts_one_for_all_worker7,
    :max_restarts_one_for_all_worker8,
    :max_restarts_one_for_all_worker9,
    :max_restarts_one_for_all_worker10
  ]

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
  end

  @impl true
  def init(:ok) do
    opts = [strategy: :one_for_all, max_restarts: 3, max_seconds: 5]
    IO.puts("#{__MODULE__} is starting, opts = #{inspect(opts)}")
    children = Enum.map(@child_names, &SimpleWorker.build_spec(&1))
    Supervisor.init(children, opts)
  end

  def test_kill_one do
    IO.puts("Before kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")
    process_name = Enum.at(@child_names, 0)
    stop_process(process_name)
    Process.sleep(500)
    IO.puts("After kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")
  end

  def test_kill_three do
    IO.puts("Before kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")

    @child_names
    |> Enum.take(3)
    |> Enum.each(fn process_name ->
      stop_process(process_name)
      Process.sleep(250)
    end)

    Process.sleep(500)
    IO.puts("After kill, Current Supervisor pid #{inspect(Process.whereis(__MODULE__))}")
  end

  def children do
    children(__MODULE__)
  end
end
