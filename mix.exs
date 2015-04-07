defmodule PersistentStorage.Mixfile do
  use Mix.Project

  def project do
    [app: :persistent_storage,
     version: "0.8.0",
     elixir: "~> 1.0",
     source_url: "https://github.com/cellulose/persistent_storage",
     homepage_url: "http://cellulose.io",
     deps: deps]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.7", only: :dev}]
  end
end
