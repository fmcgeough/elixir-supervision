defmodule Supervise.Workers.WaitWorker do
  use GenServer

  alias Supervise.Restart.StartupWait

  def start_link(opts) do
    name = opts[:name] || __MODULE__
    IO.puts("#{name} before StartupWait.register. #{inspect(Time.utc_now())}")
    StartupWait.register(name)
    IO.puts("#{name} after StartupWait.register. #{inspect(Time.utc_now())}")
    GenServer.start_link(__MODULE__, opts[:data], name: name)
  end

  def init(data) do
    {:ok, data}
  end

  def build_spec(name, restart_value \\ :permanent)
      when restart_value in [:permanent, :temporary, :transient] do
    %{
      id: name,
      start: {Supervise.Workers.WaitWorker, :start_link, [[name: name]]},
      restart: restart_value,
      type: :worker
    }
  end
end
