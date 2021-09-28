defmodule MixMachine.Format.Sarif do
  @behaviour MixMachine.Format

  @version "2.1.0"
  @schema "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-#{@version}.json"

  alias Mix.Task.Compiler.Diagnostic

  alias MixMachine.Utils

  @impl true
  def render(diagnostics, opts) do
    runs =
      diagnostics
      |> Enum.group_by(& &1.compiler_name)
      |> Enum.map(&build/1)

    Jason.encode_to_iodata!(%{
      version: @version,
      "$schema": @schema,
      runs: runs
    }, pretty: opts.pretty)
  end

  defp build({name, diagnostics}) do
    %{
      tool: %{
        driver: %{
          name: name,
          rules: []
        }
      },
      results: Enum.map(diagnostics, &into_result/1)
    }
  end

  defp into_result(%Diagnostic{} = diagnostic) do
    %{
      message: %{text: :unicode.characters_to_binary(diagnostic.message)},
      kind: kind(diagnostic.severity),
      level: level(diagnostic.severity),
      locations: locations(diagnostic),
      partialFingerprints: %{
        primaryLocationLineHash: Utils.fingerprint(diagnostic.position)
      }
    }
  end

  defp kind(:information), do: "informational"
  defp kind(_), do: "fail"

  defp level(:error), do: "error"
  defp level(:warning), do: "warning"
  defp level(:hint), do: "note"
  defp level(:information), do: "none"

  defp locations(%Diagnostic{file: file, position: position}) do
    path = Path.relative_to_cwd(file)
    {start_line, start_col, end_line, end_col} = normalize(position)

    [
      %{
        physicalLocation: %{
          artifactLocation: %{
            uri: path,
            uriBaseId: "SRCROOT"
          },
          region: %{
            startLine: start_line,
            startColumn: start_col,
            endLine: end_line,
            endColumn: end_col
          }
        }
      }
    ]
  end

  defp normalize(nil), do: {0, 0, 0, 0}
  defp normalize(line) when is_integer(line), do: {line, 0, line, 0}
  defp normalize(tuple), do: tuple
end
