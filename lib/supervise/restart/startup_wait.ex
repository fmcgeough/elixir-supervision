defmodule Supervise.Restart.StartupWait do
  @moduledoc """
  Use this module to delay process restarts.

  This module is used to delay the restart of a process. This is useful when
  a process is restarted because of a network related issue. For example, if
  you have a Kafka consumer and the connection to Kafka is lost. Restarting immediately
  can make the issue worse. It can potentially crash the Supervisor and end up
  restarting the application.
  """
  use GenServer

  @default_wait_time_ms 2_000
  @default_max_wait_time_ms 10_000

  @type process_info() :: %{num_register_calls: non_neg_integer(), last_register_time: integer()}
  @type process_key() :: String.t() | atom()
  @type process_registry() :: %{process_key() => process_info()}

  defstruct process_registry: %{},
            wait_time_ms: @default_wait_time_ms,
            max_wait_time_ms: @default_max_wait_time_ms

  @doc """
  Call this function in your GenServer start_link/1 function to register your
  process. If the GenServer has been started before then `register/2` will have
  a wait before returning :ok. If the GenServer is being started for the first
  time then `register/2` will return :ok immediately.
  """
  @spec register(unique_id :: String.t() | atom(), name :: atom()) :: :ok
  def register(unique_id, name \\ __MODULE__) do
    GenServer.call(name, {:register, unique_id}, :infinity)
  catch
    :exit, _ ->
      IO.puts("Failed to register #{unique_id}")
  end

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl true
  def init(opts) do
    IO.puts("#{__MODULE__} is starting")

    wait_time_ms = Keyword.get(opts, :default_wait_time, @default_wait_time_ms)
    max_wait_time_ms = Keyword.get(opts, :max_wait_time, @default_max_wait_time_ms)

    {:ok,
     %__MODULE__{
       wait_time_ms: wait_time_ms,
       process_registry: %{},
       max_wait_time_ms: max_wait_time_ms
     }}
  end

  @impl true
  def handle_call({:register, name}, from, %{process_registry: process_registry} = state) do
    process_registry
    |> Map.get(name)
    |> handle_register(name, from, state)
    |> case do
      {:reply, :ok, new_state} -> {:reply, :ok, new_state}
      {:noreply, new_state} -> {:noreply, new_state}
    end
  end

  @impl true
  def handle_info({:wait_on_ok_reply, from}, state) do
    GenServer.reply(from, :ok)
    {:noreply, state}
  end

  defp handle_register(nil = _process_info, name, _from, state) do
    new_registry = update_registry(state.process_registry, name, _num_calls = 1)
    {:reply, :ok, %{state | process_registry: new_registry}}
  end

  defp handle_register(%{num_register_calls: num_calls} = _process_info, name, from, state) do
    new_registry = update_registry(state.process_registry, name, num_calls)
    wait_time_ms = calculate_wait_time(num_calls, state)
    IO.puts("StartupWait will delay restart of #{name} for #{wait_time_ms}ms")
    Process.send_after(self(), {:wait_on_ok_reply, from}, wait_time_ms)
    {:noreply, %{state | process_registry: new_registry}}
  end

  defp update_registry(process_registry, name, num_calls) do
    process_info = process_info(num_calls)
    Map.put(process_registry, name, process_info)
  end

  defp process_info(num_calls) do
    current_time = System.monotonic_time(:millisecond)
    %{num_register_calls: num_calls, last_register_time: current_time}
  end

  defp calculate_wait_time(num_calls, state) do
    min(state.wait_time_ms * num_calls, state.max_wait_time_ms)
  end
end
