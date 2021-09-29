defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example_a,
      version: "0.1.0",
      build_path: "../../../_build",
      deps_path: "../../../deps",
      deps: deps(),
      machine: [
        root: "../../.."
      ]
    ]
  end

  defp deps do
    [
      {:mix_machine, path: "../../.."}
    ]
  end
end
