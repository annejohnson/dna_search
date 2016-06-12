defmodule DNASearch.NCBI do
  # API info: https://www.ncbi.nlm.nih.gov/books/NBK25500/
  # Fields info: http://www.ncbi.nlm.nih.gov/books/NBK49540/
  # Syntax info: https://www.ncbi.nlm.nih.gov/books/NBK25499/

  @doc """

  ## Parameters

    - `options`:
        `num_results`: default `20`
        `properties`: default `biomol_genomic` ([see more possible values here](http://www.ncbi.nlm.nih.gov/books/NBK49540/))
        `timeout`: default `10_000` (10 seconds)
  """
  def get_fasta(organism_name, options \\ []) do
    organism_name
    |> get_sequence_ids(options)
    |> get_fasta_for_sequence_ids
  end

  def get_sequence_ids(organism_name, options \\ []) do
    organism_name
    |> make_search_request(options)
    |> Floki.find("idlist id")
    |> Enum.map(&Floki.FlatText.get/1)
  end

  def get_fasta_for_sequence_ids(id_strings, options \\ []) do
    id_strings
    |> make_fasta_request(options)
  end

  defp make_search_request(organism_name, options) do
    make_get_request(search_url, search_params(organism_name, options), options)
  end

  defp make_fasta_request(sequence_ids, options) do
    make_get_request(fetch_url, fasta_params(sequence_ids), options)
  end

  defp search_params(organism_name, options) do
    retmax = options |> Keyword.get(:num_results, default_num_results)
    properties = options |> Keyword.get(:properties, default_properties)

    %{
      term: "#{organism_name}[primary organism] AND #{properties}[prop]",
      retmax: retmax
    }
    |> Map.merge(shared_params)
  end

  defp fasta_params(sequence_ids) do
    %{rettype: "fasta", retmode: "text", id: Enum.join(sequence_ids, ",")}
    |> Map.merge(shared_params)
  end

  defp shared_params do
    %{db: "nucleotide"}
  end

  defp make_get_request(url_endpoint, params, options) do
    url = url_endpoint <> "?" <> URI.encode_query(params)
    timeout = options |> Keyword.get(:timeout, default_timeout)
    HTTPotion.get(url, timeout: timeout).body
  end

  defp default_num_results do
    20
  end

  defp default_properties do
    "biomol_genomic"
  end

  defp default_timeout do
    10_000
  end

  defp fetch_url do
    "#{base_url}/efetch.fcgi"
  end

  defp search_url do
    "#{base_url}/esearch.fcgi"
  end

  defp base_url do
    "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
  end
end
