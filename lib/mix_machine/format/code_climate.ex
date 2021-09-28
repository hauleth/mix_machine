defmodule MixMachine.Format.CodeClimate do
  @behaviour MixMachine.Format

  alias Mix.Task.Compiler.Diagnostic

  alias MixMachine.Utils

  @impl true
  def render(diagnostics, opts) do
    diagnostics
    |> Enum.map(&encode/1)
    |> Jason.encode_to_iodata!(pretty: opts.pretty)
  end

  defp encode(%Diagnostic{} = entry) do
    %{
      severity: severity(entry.severity),
      category: entry.compiler_name,
      description: :unicode.characters_to_binary(entry.message),
      fingerprint: Utils.fingerprint(entry),
      location: %{
        path: Path.relative_to_cwd(entry.file),
        lines: %{
          begin: line(entry.position)
        }
      }
    }
  end

  defp severity(:error), do: :critical
  defp severity(:warning), do: :major
  defp severity(:hint), do: :minor
  defp severity(:information), do: :info

  defp line(nil), do: 0
  defp line({line, _, _, _}), do: line
  defp line(line), do: line
end
