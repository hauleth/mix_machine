defmodule MixMachine.Utils do
  @moduledoc false

  def fingerprint(data) do
    data
    |> :erlang.term_to_binary()
    |> :erlang.md5()
    |> Base.encode16(case: :lower)
  end
end
