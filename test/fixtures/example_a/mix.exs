defmodule ExampleA.MixProject do
  use Mix.Project

  def project do
    [
      app: :example_a,
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      build_path: "../../../_build",
      deps_path: "../../../deps",
      deps: deps(),
      machine: [
        root: "../../.."
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_machine, path: "../../.."}
    ]
  end
end
