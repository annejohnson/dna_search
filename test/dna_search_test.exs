defmodule DNASearchTest do
  use ExUnit.Case
  doctest DNASearch

  test "get_sequences_for_species" do
    species = "Pionus maximiliani"
    results = DNASearch.get_sequences_for_species(species)

    refute(Enum.empty?(results))

    first_result = hd(results)
    assert(first_result =~ ~r/\A[ATGC]+\Z/)
  end
end
