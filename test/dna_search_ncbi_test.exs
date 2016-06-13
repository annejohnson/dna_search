defmodule DNASearchNCBITest do
  use ExUnit.Case
  doctest DNASearch.NCBI

  test "get_fasta returns a valid FASTA string" do
    result = DNASearch.NCBI.get_fasta("water buffalo")

    assert(FASTA.valid_string?(result))
  end

  test "get_fasta accepts a :num_results option to control the number of records returned" do
    small_result = DNASearch.NCBI.get_fasta("Orchidaceae", num_results: 2)
    assert(length(FASTA.parse_string(small_result)) == 2)

    large_result = DNASearch.NCBI.get_fasta("Orchidaceae", num_results: 40)
    assert(length(FASTA.parse_string(large_result)) == 40)
  end

  test "get_fasta accepts a :start_at_record_index option to enable paging" do
    page1 = DNASearch.NCBI.get_fasta("Orchidaceae", num_results: 1, start_at_record_index: 0)
    page2 = DNASearch.NCBI.get_fasta("Orchidaceae", num_results: 1, start_at_record_index: 1)

    refute(page1 == page2)
  end

  test "get_fasta accepts a :properties option" do
    genomic_dna_result = DNASearch.NCBI.get_fasta(
      "Homo sapiens",
      num_results: 1,
      properties: "biomol_genomic"
    )
    mitochondrial_dna_result = DNASearch.NCBI.get_fasta(
      "Homo sapiens",
      num_results: 1,
      properties: "gene_in_mitochondrion"
    )

    refute(genomic_dna_result == mitochondrial_dna_result)
  end

  test "get_sequence_ids returns a list of id strings" do
    results = DNASearch.NCBI.get_sequence_ids("Angraecum eburneum")

    assert(
      results
      |> Enum.map(fn(result) -> result =~ ~r/\A\d+\Z/ end)
      |> Enum.all?
    )
  end

  test "get_fasta_for_sequence_ids returns a valid FASTA string" do
    result = DNASearch.NCBI.get_fasta_for_sequence_ids(["1027888907"])

    assert(FASTA.valid_string?(result))
  end
end
