defmodule DNASearch do
  @moduledoc """
  Provides functions for getting DNA sequence data by organism name.
  """

  alias DNASearch.NCBI, as: API

  @doc """
  Returns a list of sequence strings for the organism.

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `Homo sapiens` over `human`.

  ## Examples

      iex> sequences = DNASearch.get_sequences("Pionus maximiliani")
      ...> List.first(sequences)
      "CGCGAAACAGGTGTCTCTTGGTTCCGACTGACCTGTGCTTTTATGAGCTTGTTGGTTTAGTTAGTTTGTTGGGGGTTGTTGGGTTTTGGGTTTGGGTTTTTTTCCTCCTTTTCTAGACACATATTTTTGACAGGCTGTATAAAACTTTACTTATCTTTGTTAATAATGTAGCTTTGAACTACTTATTCTGACATTCCAGATCAGCTTTAATGGAAGTGAAGGGAGGCGAAGTAGGAGTAGAAGATACTCTGGATCTGATAGTGACTCTATCTCGGAAAGGAAACGGCCAAAAAAGCGTGGAAGACCACGAACTATTCCTCGAGAAAATATT"
  """
  def get_sequences(organism_name) do
    organism_name
    |> get_fasta_data
    |> Enum.map(fn(datum) -> datum.sequence end)
  end

  @doc """
  Returns a list of FASTA sequence data for the organism.

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `Homo sapiens` over `human`.

  ## Examples

      iex> fasta_data = DNASearch.get_fasta_data("Pionus maximiliani")
      ...> List.first(fasta_data)
      %FASTA.Datum{
        header: "gi|925719343|gb|KR019962.1| Pionus maximiliani voucher PMAX-COESP chromo-helicase-DNA binding protein-Z (CHDZ) gene, exons 23, 24 and partial cds",
        sequence: "CGCGAAACAGGTGTCTCTTGGTTCCGACTGACCTGTGCTTTTATGAGCTTGTTGGTTTAGTTAGTTTGTTGGGGGTTGTTGGGTTTTGGGTTTGGGTTTTTTTCCTCCTTTTCTAGACACATATTTTTGACAGGCTGTATAAAACTTTACTTATCTTTGTTAATAATGTAGCTTTGAACTACTTATTCTGACATTCCAGATCAGCTTTAATGGAAGTGAAGGGAGGCGAAGTAGGAGTAGAAGATACTCTGGATCTGATAGTGACTCTATCTCGGAAAGGAAACGGCCAAAAAAGCGTGGAAGACCACGAACTATTCCTCGAGAAAATATT"
      }
  """
  def get_fasta_data(organism_name) do
    organism_name
    |> API.get_fasta
    |> FASTA.parse_string
  end
end
