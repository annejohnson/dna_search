defmodule DNASearchTest do
  use ExUnit.Case
  doctest DNASearch

  test "get_sequences" do
    organism = "Pionus maximiliani"
    results = DNASearch.get_sequences(organism)

    assert(
      results
      |> Enum.map(&DNASearchTestHelper.valid_sequence?/1)
      |> Enum.all?
    )
  end

  test "get_fasta_data" do
    organism = "water buffalo"
    results = DNASearch.get_fasta_data(organism)

    assert(
      results
      |> Enum.map(fn(result) -> result.sequence end)
      |> Enum.map(&DNASearchTestHelper.valid_sequence?/1)
      |> Enum.all?
    )

    assert(
      results
      |> Enum.map(fn(result) -> result.header end)
      |> Enum.map(&is_binary/1)
      |> Enum.all?
    )
  end
end
