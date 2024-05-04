# Supervise

Sample code related to Elixir/OTP Supervision

## Installation/Usage

This repo is used to demonstrate some aspects of Supervision in
Elixir. To use it do the folowing:

- asdf install
- mix deps.get
- iex -S mix

You'll see some output as various processes are started that are
used to demo aspects of Supervision. Example:

```
Elixir.Supervise.Application is starting
Elixir.Supervise.Restart.StartupWait GenServer is starting
Elixir.Supervise.Strategies.SuperviseOneForOne is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.Strategies.SuperviseRestForOne is starting, opts = [strategy: :rest_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.Strategies.SuperviseOneForAll is starting, opts = [strategy: :one_for_all, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.Strategies.SuperviseLevels is starting, opts = [strategy: :rest_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.Strategies.SuperviseLevels.ChildSupervisor is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 1]
Elixir.Supervise.Types.SuperviseDynamically is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5, max_children: 10, extra_arguments: []]
Elixir.Supervise.RestartTypes.Permanent is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.RestartTypes.Temporary is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.RestartTypes.Transient is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.MaxRestarts.UsingOneForOne is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.MaxRestarts.UsingOneForAll is starting, opts = [strategy: :one_for_all, max_restarts: 3, max_seconds: 5]
Elixir.Supervise.Restart.WithWait is starting, opts = [strategy: :one_for_one, max_restarts: 3, max_seconds: 5]
```
