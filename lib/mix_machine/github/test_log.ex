defmodule MixMachine.Github.TestLog do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, [])

  def init(_), do: {:ok, []}

  def handle_cast({:test_finished, test}, state) do
    format_test(test)
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

  defp format_test(%ExUnit.Test{state: {:failed, _failures}} = test) do
    C.error("Test #{test.name} failed", meta(test))
  end

  defp format_test(%ExUnit.Test{state: {:invalid, module}} = test) do
    C.error(
      "Test #{test.name} is invalid because `setup_all` in #{inspect(module)} failed",
      meta(test)
    )
  end

  defp format_test(%ExUnit.Test{state: {:excluded, filter}} = test) do
    C.notice("Test #{test.name} excluded by #{filter}", meta(test))
  end

  defp format_test(%ExUnit.Test{state: {:skipped, reason}} = test) do
    C.notice("Test #{test.name} skipped because of #{reason}", meta(test))
  end

  defp format_test(%ExUnit.Test{name: name, state: nil}) do
    C.debug("Test #{name} passed")
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
