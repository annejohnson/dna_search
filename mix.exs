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
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp description do
    "DNASearch is a tool for looking up DNA sequences in Elixir."
  end
end
