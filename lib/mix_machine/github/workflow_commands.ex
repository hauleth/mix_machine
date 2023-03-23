defmodule MixMachine.Github.WorkflowCommands do
  @doc """
  Print debug message
  """
  def debug(message), do: print(:debug, message)

  @log_metadata [:title, :file, :col, :end_column, :line, :end_line]

  @doc """
  Log message using `notice` level
  """
  def notice(message, meta \\ %{}),
    do: print(:notice, Map.take(meta, @log_metadata), message)

  @doc """
  Log message using `warning` level
  """
  def warning(message, meta \\ %{}),
    do: print(:warning, Map.take(meta, @log_metadata), message)

  @doc """
  Log message using `error` level
  """
  def error(message, meta \\ %{}),
    do: print(:error, Map.take(meta, @log_metadata), message)

  def group(name, callback) do
    print(:group, name)
    return = callback.()
    print(:endgroup)

    return
  end

  def set_output(name, value) do
    print("set-output", %{name: name}, value)
  end

  def set_secret(value), do: print("add-mask", value)

  defp print(command), do: print(command, %{}, "")

  defp print(command, message), do: print(command, %{}, message)

  defp print(command, meta, message) do
    IO.puts(["::", to_string(command), format_meta(meta), "::", message])
  end

  defp format_meta(map) when map == %{}, do: ""

  defp format_meta(map) do
    values =
      for {key, value} <- map do
        [format_key(key), "=", to_string(value)]
      end

    [" " | Enum.intersperse(values, ",")]
  end

  # Change `key` to real camel case (first letter lowercase and rest mixed case)
  defp format_key(key) do
    <<c, rest::binary>> = Macro.camelize(to_string(key))

    String.downcase(<<c>>) <> rest
  end
end
