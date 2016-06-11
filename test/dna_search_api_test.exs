defmodule DNASearchAPITest do
  use ExUnit.Case
  doctest DNASearch.API

  test "get_sequence_ids" do
    species = "Polypodium hesperium"
    results = DNASearch.API.get_sequence_ids(species)

    first_result = hd(results)
    assert(first_result =~ ~r/\A\d+\Z/)
  end
end
