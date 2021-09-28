defmodule Mix.Tasks.Compile.Machine do
  use Mix.Task.Compiler

  @opts [
    strict: [
      output: :string,
      format: :string,
      pretty: :boolean
    ],
    alias: [
      o: :output,
      f: :format
    ]
  ]

  @impl true
  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, @opts)

    output = Keyword.get(opts, :output, "report.json")
    format = Keyword.get(opts, :format, "sarif")
    pretty = Keyword.get(opts, :pretty, false)

    formatter =
      case format(format) do
        {:ok, formatter} -> formatter
        _ -> Mix.raise("Unknown format #{format}", exit_status: 2)
      end

    with {status, diagnostics} <- Mix.Task.run("compile", argv) do
      File.write!(
        output,
        formatter.render(diagnostics, %{
          pretty: pretty
        })
      )

      {status, diagnostics}
    end
  end

  defp format(name) do
    camelized = Macro.camelize(name)
    {:ok, Module.safe_concat(MixMachine.Format, camelized)}
  rescue
    ArgumentError -> :error
  end
end
