defmodule DNASearch.API do
  def get_sequences(query) do
    get_sequence_ids(query)
    |> get_fasta_data
    |> Enum.map(&FASTA.get_sequence/1)
  end

  def get_fasta_data(ids) do
    FASTA.parse(make_fasta_request(ids))
  end

  def make_fasta_request(ids) do
    params = Map.merge(fetch_params, %{id: Enum.join(ids, ",")})
    request_url = fasta_url <> "?" <> URI.encode_query(params)
    HTTPotion.get(request_url, timeout: timeout_in_milliseconds).body
  end

  def get_sequence_ids(query) do
    make_sequence_id_search_request(query).body
    |> Floki.find("idlist id")
    |> Enum.map(&Floki.FlatText.get/1)
  end

  def make_sequence_id_search_request(query) do
    params = Map.merge(shared_params, %{term: query})
    url = search_url <> "?" <> URI.encode_query(params)
    HTTPotion.get(url, timeout: timeout_in_milliseconds)
  end

  def shared_params do
    %{db: "nucleotide"}
  end

  def fetch_params do
    Map.merge(shared_params, %{rettype: "fasta", retmode: "text"})
  end

  def timeout_in_milliseconds do
    10_000
  end

  def fasta_url do
    "#{base_url}/efetch.fcgi"
  end

  def search_url do
    "#{base_url}/esearch.fcgi"
  end

  def base_url do
    "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
  end
end
