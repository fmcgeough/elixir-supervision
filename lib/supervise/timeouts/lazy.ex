defmodule Supervise.Timeouts.Lazy do
  use Supervisor

  import Supervise.Utils.Process

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    sleep_ms = Keyword.get(opts, :start_link_delay, 0)
    IO.puts("#{__MODULE__}.start_link/1 has name #{name}")
    IO.puts("#{__MODULE__}.start_link/1 will call Supervisor.start_link in #{sleep_ms} ms")
    Process.sleep(sleep_ms)
    Supervisor.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    sleep_ms = Keyword.get(opts, :init_delay, 0)
    IO.puts("#{__MODULE__}.init/1 will continue in #{sleep_ms} ms")
    Process.sleep(sleep_ms)

    opts = [
      strategy: :one_for_one,
      max_restarts: 3,
      max_seconds: 5,
      max_children: 10
    ]

    Supervisor.init([], opts)
  end

  def stop do
    stop_process(__MODULE__)
  end
end
