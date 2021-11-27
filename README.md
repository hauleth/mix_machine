# MixMachine

Make Mix compilation produce report that is machine-readable.

Currently supported formats:

- [SARIF][] used by [GitHub Code Scanning][gha]
- [CodeClimate][cc] used by [GitLab Code Quality][gl-cq]

[SARIF]: https://sarifweb.azurewebsites.net
[gha]: https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning
[cc]: https://codeclimate.com/customers/
[gl-cq]: https://docs.gitlab.com/ee/user/project/merge_requests/code_quality.html

## Usage

Add it to list of your dependencies:

```elixir
def deps do
  [
    {:mix_machine, "~> 0.1.0"}
  ]
end
```

And now you can use:

```
$ mix compile.machine
```

That will produce `report.json` with SARIF format.

## Configration

Current behaviour can be controlled by few flags:

 + `--format <format>` (`-f`) - output format, currently supported values are
   `sarif` and `code_climate`, defaults to `sarif`.
 + `--output <path>` (`-o`) - output file, defaults to `report.json`.
 + `--pretty` - pretty print output.

In addition to CLI flags these options can be set in `project/0` function in
`mix.exs` in `:machine` keyword list (it has lower precedence than CLI flags):

 + `:format` - atom `:sarif` or `:code_climate` that describes default format.
 + `:output` - default filename to produce output.
 + `:pretty` - boolean flag whether the output should be pretty printed.
 + `:root` - relative path to root directory, defaults to current working
   directory. It can be useful in situations when you have multirepo where
   the Elixir application isn't mounted at root of the repository.

### Example

```elixir
def project do
  [
    # …
    machine: [
      format: :code_climate,
      output: "codeclimate.json",
      pretty: true,
      root: ".."
    ]
  ]
```

### Usage in GitHub Actions

In your github `.yml` file, after you download Elixir deps, compile your project
with `mix mix_machine.compile`.

``` yaml
    - name: Compile Deps
      run: mix deps.compile
    - name: Compile Project
      run: mix compile.machine
```

Note: This must come before any other lines that would inadvertently compile
your code such as `mix test`!

Note: the `mix deps.compile` in a separate step is not required but it can be
helpful to separate any compilation warnings in your project from any
compilation warnings in your deps.

Then later in the `.yml` file add this to upload your Sarif file to your GitHub repository:
``` yaml
    - name: Upload Sarif
      uses: github/codeql-action/upload-sarif@v1
      with:
        sarif_file: report.json
```

## License

See [LICENSE](LICENSE).
