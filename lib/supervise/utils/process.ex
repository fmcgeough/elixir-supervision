defmodule Supervise.Utils.Process do
  @test_step "------ "

  def stop_child(process_name) do
    case stop_process(process_name) do
      nil ->
        IO.puts("No such process")

      pid ->
        IO.puts("Killing the process #{inspect(pid)}")
    end
  end

  def stop_process(process_name) do
    process_name
    |> Process.whereis()
    |> case do
      nil ->
        nil

      pid ->
        Process.exit(pid, :kill)
        pid
    end
  end

  def show_children(module) do
    children_info =
      module
      |> children()
      |> Enum.map(fn {name, pid, _, _} -> "Name: #{name}, PID: #{inspect(pid)}" end)
      |> Enum.join("\n")

    IO.puts("#{children_info}\n")
  end

  def kill_process(module, process_name) do
    IO.puts(">>>>>>>> START #{process_name} \n")
    IO.puts("#{@test_step} Show children before stop #{@test_step}\n")
    show_children(module)
    IO.puts("#{@test_step} Stopping one child #{@test_step}\n")
    stop_child(process_name)
    Process.sleep(500)
    IO.puts("\n#{@test_step} Show children after stop #{@test_step}\n")
    show_children(module)
    IO.puts("<<<<< DONE #{process_name}\n")
  end

  def children(module) do
    Supervisor.which_children(module)
  end
end
