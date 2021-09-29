{input, _} = Code.eval_file("../common.exs")

import ExUnit.Assertions

results_count =
  input.report
  |> Enum.map(& &1["results_count"])
  |> Enum.sum()

assert results_count == 0
