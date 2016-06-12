defmodule DNASearch do
  defdelegate [
    get_sequences(organism_name),
    get_fasta_data(organism_name)
  ], to: DNASearch.API
end
