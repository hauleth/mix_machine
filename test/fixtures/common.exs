{opts, _, _} =
  OptionParser.parse(System.argv(),
    strict: [
      report: :string,
      token: :string
    ]
  )

Application.ensure_all_started(:inets)

defmodule Client do
  @options [
    body_format: :binary
  ]

  def get(url, token) do
    headers = [
      {'authorization', 'Bearer #{token}'},
      {'content-type', 'application/json'}
    ]

    {:ok, {200, body}} = :httpc.request(:get, {to_charlist(url), headers}, [], @options)

    Jason.decode!(body)
  end
end

report =
  opts[:report]
  |> File.read!()
  |> Jason.decode!()

IO.inspect(report, label: :report)

%{
  report: report,
  token: opts[:token]
}
