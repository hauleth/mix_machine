defmodule MixMachine.Format do
  @moduledoc """
  Behaviour for defining machine formatters.
  """

  @type opts() :: %{
          root: Path.t(),
          pretty: boolean()
        }

  @doc """
  Transform list of diagnostics into the machine readable output.
  """
  @callback render([Mix.Task.Compiler.Diagnostic.t()], opts()) :: iodata()
end
