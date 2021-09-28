defmodule MixMachine.Format.CodeClimate do
  @moduledoc """
  Produce output in subset of [CodeClimate][cc] format for use with [GitLab CI Code Quality][gl-ci].

  [cc]: https://codeclimate.com/customers/
  [gl-ci]: https://docs.gitlab.com/ee/user/project/merge_requests/code_quality.html
  """
  @behaviour MixMachine.Format

  alias Mix.Task.Compiler.Diagnostic

  alias MixMachine.Utils

  @impl true
  def render(diagnostics, opts) do
    diagnostics
    |> Enum.map(&encode(&1, opts.root))
    |> Jason.encode_to_iodata!(pretty: opts.pretty)
  end

  defp encode(%Diagnostic{} = entry, root) do
    %{
      severity: severity(entry.severity),
      category: entry.compiler_name,
      description: :unicode.characters_to_binary(entry.message),
      fingerprint: Utils.fingerprint(entry),
      location: %{
        path: Path.relative_to(entry.file, root),
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
