defmodule DNASearch.Mixfile do
  use Mix.Project

  def project do
    [app: :dna_search,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger, :httpotion]]
  end

  defp description do
    "DNASearch is a tool for looking up DNA sequences by species in Elixir."
  end

  defp deps do
    [{:httpotion, "~> 3.0.0"},
     {:floki, "~> 0.8.1"},
     {:fasta, "~> 0.1.0"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [licenses: ["MIT"],
     maintainers: ["annecodes@gmail.com"],
     links: %{"GitHub" => "https://github.com/annejohnson/dna_search"}]
  end
end
