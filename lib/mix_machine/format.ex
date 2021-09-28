defmodule MixMachine.Format do
  @type opts() :: %{
          root: Path.t(),
          pretty: boolean()
        }

  @callback render(Mix.Task.Compiler.Diagnostic.t(), opts()) :: iodata()
end
