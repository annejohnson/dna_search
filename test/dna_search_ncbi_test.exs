defmodule DNASearchNCBITest do
  use ExUnit.Case
  doctest DNASearch.NCBI

  test "get_fasta" do
    result = DNASearch.NCBI.get_fasta("water buffalo")

    assert(
      DNASearchTestHelper.valid_fasta_string?(result)
    )
  end

  test "get_sequence_ids" do
    results = DNASearch.NCBI.get_sequence_ids("Angraecum eburneum")

    assert(
      results
      |> Enum.map(fn(result) -> result =~ ~r/\A\d+\Z/ end)
      |> Enum.all?
    )
  end

  test "get_fasta_for_sequence_ids" do
    result = DNASearch.NCBI.get_fasta_for_sequence_ids(["1027888907"])

    assert(
      DNASearchTestHelper.valid_fasta_string?(result)
    )
  end
end
