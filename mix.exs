defmodule PersistentStorage.Mixfile do
  use Mix.Project

  def project do
    [app: :persistent_storage,
     version: version,
     elixir: "~> 1.0",
     source_url: "https://github.com/cellulose/persistent_storage",
     homepage_url: "http://cellulose.io",
     deps: deps]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.7", only: :dev}]
  end

  defp version do
    case File.read("VERSION") do
      {:ok, ver} -> String.strip ver
      _ -> "0.0.0-dev"
    end
  end
end
