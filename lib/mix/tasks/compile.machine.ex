defmodule Mix.Tasks.Compile.Machine do
  use Mix.Task.Compiler

  @moduledoc """
  Compile the project and produce report in machine readable format.

  ## Flags

   + `--format <format>` (`-f`) - output format, currently supported values are
     `sarif` and `code_climate`, defaults to `sarif`.
   + `--output <path>` (`-o`) - output file, defaults to `report.json`.
   + `--pretty` - pretty print output.

  ## Options

   + `:format` - atom `:sarif` or `:code_climate` that describes default format.
   + `:output` - default filename to produce output.
   + `:pretty` - boolean flag whether the output should be pretty printed.
   + `:root` - relative path to root directory, defaults to current working
     directory. It can be useful in situations when you have multirepo where
     the Elixir application isn't mounted at root of the repository.
  """

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
    {args, _, _} = OptionParser.parse(argv, @opts)
    project_config = Mix.Project.config()
    config = Keyword.get(project_config, :machine, [])

    output = option(args, config, :output, "report.json")
    format = option(args, config, :format, "sarif")
    pretty = option(args, config, :pretty, false)
    root = Path.expand(option(args, config, :root, File.cwd!()))

    formatter =
      case format(format) do
        {:ok, formatter} -> formatter
        _ -> Mix.raise("Unknown format #{format}", exit_status: 2)
      end

    {status, diagnostics} =
      case Mix.Task.run("compile", argv) do
        {_, _} = result -> result
        status -> {status, []}
      end

    File.write!(
      output,
      formatter.render(diagnostics, %{
        pretty: pretty,
        root: root
      })
    )

    {status, diagnostics}
  end

  defp format(name) do
    camelized = Macro.camelize(to_string(name))
    {:ok, Module.safe_concat(MixMachine.Format, camelized)}
  rescue
    ArgumentError -> :error
  end

  defp option(args, config, key, default) do
    Keyword.get_lazy(args, key, fn -> Keyword.get(config, key, default) end)
  end
end
