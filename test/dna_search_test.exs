defmodule DNASearchTest do
  use ExUnit.Case
  doctest DNASearch

  test "get_sequences" do
    organism = "Pionus maximiliani"
    results = DNASearch.get_sequences(organism)

    assert(
      results
      |> Enum.map(&valid_sequence?/1)
      |> Enum.all?
    )
  end

  test "get_fasta_data" do
    organism = "water buffalo"
    results = DNASearch.get_fasta_data(organism)

    assert(
      results
      |> Enum.map(&(&1.sequence))
      |> Enum.map(&valid_sequence?/1)
      |> Enum.all?
    )

    assert(
      results
      |> Enum.map(&(&1.header))
      |> Enum.map(&is_binary/1)
      |> Enum.all?
    )
  end

  defp valid_sequence?(str) do
    str =~ ~r/\A[#{nucleotide_codes}\-]+\Z/i
  end

  defp nucleotide_codes do
    "ACGTURYKMSWBDHVN"
  end
end
