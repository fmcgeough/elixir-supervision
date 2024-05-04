defmodule Supervise.Strategies.SuperviseLevels.ChildSupervisor do
  use Supervisor

  import Supervise.Utils.Process

  alias Supervise.Workers.SimpleWorker

  @child_names [:child_supervisor_worker1, :child_supervisor_worker2, :child_supervisor_worker3]

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
  end

  @impl true
  def init(:ok) do
    IO.puts("#{__MODULE__} is starting")
    children = Enum.map(@child_names, &SimpleWorker.build_spec(&1))
    opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 1]
    Supervisor.init(children, opts)
  end

  # Spawn processes to kill the child processes as quickly as possible
  def test_restarts(num_restarts) do
    Enum.reduce(1..num_restarts, @child_names, fn _, acc ->
      [h | t] = acc
      spawn(fn -> stop_process(h) end)
      Process.sleep(5)
      Enum.concat(t, [h])
    end)

    :ok
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

  def show_children do
    show_children(__MODULE__)
  end
end
