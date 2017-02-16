defmodule PersistentStorage.Mixfile do
  use Mix.Project

  @version "0.10.0"

  def project do
    [app: :persistent_storage,
     version: @version,
     elixir: "~> 1.4",
     deps: deps(),
     description: "Brain dead simple file-based storage for embedded systems",
     package: package(),
     name: "PersistentStorage",
     docs: [
       source_ref: "v#{@version}", main: "PersistentStorage",
       source_url: "https://github.com/ghitchens/persistent_storage",
#       main: "extra-readme",
       extras: [ "README.md", "CHANGELOG.md"] ]]
  end

  def application do
    [ mod: {PersistentStorage, []} ]
  end

  defp deps do
    [{:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [ maintainers: ["Garth Hitchens", "Chris Dutton"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/ghitchens/persistent_storage"},
      files: ~w(lib config) ++ ~w(README.md CHANGELOG.md LICENSE mix.exs) ]
  end
end
