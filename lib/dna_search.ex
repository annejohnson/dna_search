defmodule DNASearch do
  alias DNASearch.API

  def get_sequences_for_species(species) do
    API.get_sequences(species)
  end
end
