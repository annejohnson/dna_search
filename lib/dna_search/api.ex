defmodule DNASearch.API do
  def get_sequences(query) do
    params = Map.merge(shared_search_params, %{term: query})
    url = base_url <> "?" <> URI.encode_query(params)
    HTTPotion.get(url, timeout: timeout_in_milliseconds)
  end

  def shared_search_params do
    %{db: "nucleotide"}
  end

  def timeout_in_milliseconds do
    10_000
  end

  def base_url do
    "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
  end
end
