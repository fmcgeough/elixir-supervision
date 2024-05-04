defmodule Supervise.Workers.SimpleWorker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts[:data], name: opts[:name] || __MODULE__)
  end

  def init(data) do
    Process.flag(:trap_exit, true)
    {:ok, data}
  end

  def terminate(reason, state) do
    IO.puts(
      "Terminating #{inspect(self())} with reason #{inspect(reason)} and state #{inspect(state)}"
    )
  end

  def build_spec(name, restart_value \\ :permanent)
      when restart_value in [:permanent, :temporary, :transient] do
    %{
      id: name,
      start: {Supervise.Workers.SimpleWorker, :start_link, [[name: name]]},
      restart: restart_value,
      type: :worker
    }
  end
end
