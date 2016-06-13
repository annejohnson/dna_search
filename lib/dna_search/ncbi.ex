defmodule DNASearch.NCBI do
  # API info: https://www.ncbi.nlm.nih.gov/books/NBK25500/
  # Fields info: http://www.ncbi.nlm.nih.gov/books/NBK49540/
  # Syntax info: https://www.ncbi.nlm.nih.gov/books/NBK25499/

  @doc """

  ## Parameters

    - `options`:
        `num_records`: default `20`
        `start_at_record_index`: default `0` to start at the first record
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
    if Enum.any?(id_strings) do
      id_strings
      |> make_fasta_request(options)
    else
      ""
    end
  end

  defp make_search_request(organism_name, options) do
    make_get_request(search_url, search_params(organism_name, options), options)
  end

  defp make_fasta_request(sequence_ids, options) do
    make_get_request(fetch_url, fasta_params(sequence_ids), options)
  end

  defp search_params(organism_name, options) do
    retmax = options |> Keyword.get(:num_records, default_num_records)
    retstart = options |> Keyword.get(:start_at_record_index, default_start_at_record_index)
    properties = options |> Keyword.get(:properties, default_properties)

    %{
      term: "#{organism_name}[primary organism] AND #{properties}[prop]",
      retmax: retmax,
      retstart: retstart
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
    response = HTTPotion.get(url, timeout: timeout)

    case response do
      %{body: response_body} ->
        response_body
      _ ->
        ""
    end
  end

  defp default_num_records do
    20
  end

  defp default_start_at_record_index do
    0
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
