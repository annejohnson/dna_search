defmodule DNASearch do
  @moduledoc """
  Provides functions for getting DNA sequence data by organism name.
  """

  alias DNASearch.NCBI, as: API

  @doc """
  Returns a list of sequence strings for the organism.

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `"Homo sapiens"` over `"human"`.
    - `options` (optional):
      - See `DNASearch.NCBI.get_fasta/2` for permitted options.

  ## Examples

      iex> [sequence] = DNASearch.get_sequences("Pionus maximiliani", limit: 1)
      ...> sequence
      "CGCGAAACAGGTGTCTCTTGGTTCCGACTGACCTGTGCTTTTATGAGCTTGTTGGTTTAGTTAGTTTGTTGGGGGTTGTTGGGTTTTGGGTTTGGGTTTTTTTCCTCCTTTTCTAGACACATATTTTTGACAGGCTGTATAAAACTTTACTTATCTTTGTTAATAATGTAGCTTTGAACTACTTATTCTGACATTCCAGATCAGCTTTAATGGAAGTGAAGGGAGGCGAAGTAGGAGTAGAAGATACTCTGGATCTGATAGTGACTCTATCTCGGAAAGGAAACGGCCAAAAAAGCGTGGAAGACCACGAACTATTCCTCGAGAAAATATT"
  """
  def get_sequences(organism_name, options \\ []) do
    organism_name
    |> get_fasta_data(options)
    |> Enum.map(&(&1.sequence))
  end

  @doc """
  Returns a list of FASTA sequence data for the organism.

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `"Homo sapiens"` over `"human"`.
    - `options` (optional):
      - See `DNASearch.NCBI.get_fasta/2` for permitted options.

  ## Examples

      iex> fasta_data = DNASearch.get_fasta_data("Pionus maximiliani")
      ...> List.first(fasta_data)
      %FASTA.Datum{
        header: "gi|925719343|gb|KR019962.1| Pionus maximiliani voucher PMAX-COESP chromo-helicase-DNA binding protein-Z (CHDZ) gene, exons 23, 24 and partial cds",
        sequence: "CGCGAAACAGGTGTCTCTTGGTTCCGACTGACCTGTGCTTTTATGAGCTTGTTGGTTTAGTTAGTTTGTTGGGGGTTGTTGGGTTTTGGGTTTGGGTTTTTTTCCTCCTTTTCTAGACACATATTTTTGACAGGCTGTATAAAACTTTACTTATCTTTGTTAATAATGTAGCTTTGAACTACTTATTCTGACATTCCAGATCAGCTTTAATGGAAGTGAAGGGAGGCGAAGTAGGAGTAGAAGATACTCTGGATCTGATAGTGACTCTATCTCGGAAAGGAAACGGCCAAAAAAGCGTGGAAGACCACGAACTATTCCTCGAGAAAATATT"
      }
  """
  def get_fasta_data(organism_name, options \\ []) do
    organism_name
    |> API.get_fasta(options)
    |> FASTA.parse_string
  end
end
