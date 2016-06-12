defmodule DNASearch do
  alias DNASearch.NCBI, as: API

  def get_sequences(organism_name) do
    organism_name
    |> get_fasta_data
    |> Enum.map(fn(datum) -> datum.sequence end)
  end

  def get_fasta_data(organism_name) do
    organism_name
    |> API.get_fasta
    |> FASTA.parse_string
  end
end
