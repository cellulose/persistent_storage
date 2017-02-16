defmodule PersistentStorage.Mixfile do
  use Mix.Project

  @version "0.10.1"

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
       source_url: "https://github.com/cellulose/persistent_storage",
#       main: "extra-readme",
       extras: [ "README.md", "CHANGELOG.md"] ]]
  end

  def application do
    [ mod: {PersistentStorage, []} ]
  end

  defp deps do
    [{:ex_doc, "~> 0.12", only: :dev}]
  end

  defp package do
    [ maintainers: ["Garth Hitchens", "Chris Dutton"],
      licenses: ["Apache-2.0"],
      links: %{github: "https://github.com/cellulose/persistent_storage"},
      files: ~w(lib config) ++ ~w(README.md CHANGELOG.md LICENSE mix.exs) ]
  end
end
