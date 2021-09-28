defmodule MixMachine.Format do
  @type opts() :: %{
          pretty: boolean()
        }

  @callback render(Mix.Task.Compiler.Diagnostic.t(), opts()) :: iodata()
end
