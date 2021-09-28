defmodule MixMachine.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_machine,
      description: "Produce machine readable output from Mix",
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        links: %{
          "GitHub" => "https://github.com/hauleth/mix_machine"
        },
        licenses: ~w[MIT]
      ],
      docs: [
        main: "Mix.Tasks.Compile.Machine",
        groups_for_modules: [
          Formats: ~r/^MixMachine\.Format\./
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0"},
      {:credo, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
