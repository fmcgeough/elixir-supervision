defmodule Supervise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("#{__MODULE__} is starting")

    children = [
      Supervise.Restart.StartupWait,
      Supervise.Strategies.SuperviseOneForOne,
      Supervise.Strategies.SuperviseRestForOne,
      Supervise.Strategies.SuperviseOneForAll,
      Supervise.Strategies.SuperviseLevels,
      Supervise.Types.SuperviseDynamically,
      Supervise.RestartTypes.Permanent,
      Supervise.RestartTypes.Temporary,
      Supervise.RestartTypes.Transient,
      Supervise.MaxRestarts.SuperviseOneForOne,
      Supervise.MaxRestarts.SuperviseOneForAll,
      # Supervise.Timeouts.LazySupervisor,
      Supervise.Restart.WithWait
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Supervise.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
