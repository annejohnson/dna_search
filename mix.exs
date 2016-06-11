defmodule DNASearch.Mixfile do
  use Mix.Project

  def project do
    [app: :dna_search,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpotion]]
  end

  defp deps do
    [{:httpotion, "~> 3.0.0"}]
  end

  defp description do
    "DNASearch is a tool for looking up DNA sequences by species in Elixir."
  end
end
