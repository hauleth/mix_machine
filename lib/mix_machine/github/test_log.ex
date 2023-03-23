defmodule MixMachine.Github.TestLog do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, [])

  def init(_) do
    counter = :atomics.new(1, [])

    {:ok, %{counter: counter}}
  end

  def handle_cast({:test_finished, test}, state) do
    format_test(test, state)

    {:noreply, state}
  end

  def handle_cast({event, _}, state) when event in ~w[case_started case_finished]a do
    {:noreply, state}
  end

  def handle_cast(_msg, state) do
    # IO.inspect(msg)
    {:noreply, state}
  end

  alias MixMachine.Github.WorkflowCommands, as: C

  defp format_test(%ExUnit.Test{state: {:failed, failures}} = test, %{counter: counter}) do
    id = :atomics.add_get(counter, 1, 1)

    C.error("#{test.name} failed", meta(test))

    C.group("#{test.name} report", fn ->
      IO.puts("")
      IO.puts(
        ExUnit.Formatter.format_test_failure(test, failures, id, 80, fn _, msg -> msg end)
      )
    end)
  end

  defp format_test(%ExUnit.Test{state: {:invalid, module}} = test, %{counter: counter}) do
    _id = :atomics.add_get(counter, 1, 1)

    C.error(
      "#{test.name} is invalid because `setup_all` in #{inspect(module)} failed",
      meta(test)
    )
  end

  defp format_test(%ExUnit.Test{state: {:excluded, filter}} = test, %{counter: counter}) do
    _id = :atomics.add_get(counter, 1, 1)

    C.notice("#{test.name} excluded by #{filter}", meta(test))
  end

  defp format_test(%ExUnit.Test{state: {:skipped, reason}} = test, _state) do
    C.notice("#{test.name} skipped because of #{reason}", meta(test))
  end

  defp format_test(%ExUnit.Test{name: name, state: nil}, _state) do
    C.debug("#{name} passed")
  end

  defp meta(%ExUnit.Test{tags: tags}) do
    tags
    |> Map.take([:file, :line])
    |> update(:file, &Path.relative_to_cwd/1)
  end

  defp update(map, key, func) when is_map_key(map, key),
    do: %{map | key => func.(Map.fetch!(map, key))}

  defp update(map, _key, _func), do: map
end
