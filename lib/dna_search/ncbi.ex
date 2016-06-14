defmodule DNASearch.NCBI do
  @moduledoc """
  Provides functions for querying the NCBI Nucleotide database for DNA sequence records.

  #### Links to API Documentation:
  - [General API info](https://www.ncbi.nlm.nih.gov/books/NBK25500/)
  - [Nucleotide fields](http://www.ncbi.nlm.nih.gov/books/NBK49540/)
  - [Query syntax info](https://www.ncbi.nlm.nih.gov/books/NBK25499/)
  """

  alias DNASearch.FlokiUtils

  @doc """
  Returns a raw FASTA string containing DNA data associated with the organism.

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `Homo sapiens` over `human`.
    - `options` (optional):
      - `num_records` (optional): number of records to include in the FASTA. default: `20`.
      - `start_at_record_index` (optional): the index of the first record to return.
         default: `0` to return the first set of records.
      - `properties` (optional): string specifying special properties to filter by.
        default: `biomol_genomic` to filter to genomic sequences. [see possible values for this field here](http://www.ncbi.nlm.nih.gov/books/NBK49540/).
      - `timeout` (optional): request timeout in milliseconds. default: `10_000` (10 seconds).
  """
  def get_fasta(organism_name, options \\ []) do
    organism_name
    |> get_sequence_ids(options)
    |> get_fasta_for_sequence_ids
  end

  @doc """
  Queries NCBI for sequence records and returns a map containing the following keys:
    - `ids`: NCBI record IDs corresponding to sequences
    - `start_at_record_index`: the index of the first ID in the current result set
    - `num_records`: the number of record IDs in the current result set
    - `total_num_records`: the total number of matching record IDs

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `Homo sapiens` over `human`.
    - `options` (optional):
      - `num_records` (optional): number of records to include in the result set. default: `20`.
      - `start_at_record_index` (optional): the index of the first record to return.
         default: `0` to return the first set of records.
      - `properties` (optional): string specifying special properties to filter by.
        default: `biomol_genomic` to filter to genomic sequences. [see possible values for this field here](http://www.ncbi.nlm.nih.gov/books/NBK49540/).
      - `timeout` (optional): request timeout in milliseconds. default: `10_000` (10 seconds).
  """
  def get_sequence_records(organism_name, options \\ []) do
    response_string = organism_name |> make_search_request(options)
    ids = extract_id_strings(response_string)

    %{
      ids: ids,
      start_at_record_index: extract_start_at_record_index(response_string),
      num_records: length(ids),
      total_num_records: extract_total_num_records(response_string)
    }
  end

  @doc """
  Returns a list of NCBI IDs (strings) for sequences associated with the organism.

  ## Parameters

    - `organism_name`: name of the organism you're interested in.
      works best as a species names, e.g. `Homo sapiens` over `human`.
    - `options` (optional):
      - `num_records` (optional): number of records to include in the results. default: `20`.
      - `start_at_record_index` (optional): the index of the first record to return.
         default: `0` to return the first set of records.
      - `properties` (optional): string specifying special properties to filter by.
        default: `biomol_genomic` to filter to genomic sequences. [see possible values for this field here](http://www.ncbi.nlm.nih.gov/books/NBK49540/).
      - `timeout` (optional): request timeout in milliseconds. default: `10_000` (10 seconds).
  """
  def get_sequence_ids(organism_name, options \\ []) do
    get_sequence_records(organism_name, options).ids
  end

  @doc """
  Returns a raw FASTA string containing the sequences for the specified record IDs.

  ## Parameters

    - `id_strings`: list of NCBI ID strings corresponding to sequence records
    - `options` (optional):
      - `timeout` (optional): request timeout in milliseconds. default: `10_000` (10 seconds).
  """
  def get_fasta_for_sequence_ids(id_strings, options \\ [])
  def get_fasta_for_sequence_ids([], _), do: ""
  def get_fasta_for_sequence_ids(id_strings, options) do
    id_strings
    |> make_fasta_request(options)
  end

  defp make_search_request(organism_name, options) do
    make_get_request(search_url, search_params(organism_name, options), options)
  end

  defp extract_id_strings(response_string) do
    response_string
    |> Floki.find("idlist id")
    |> Enum.map(&Floki.FlatText.get/1)
  end

  defp extract_start_at_record_index(response_string) do
    response_string
    |> Floki.find("retstart")
    |> FlokiUtils.get_integer
  end

  defp extract_total_num_records(response_string) do
    response_string
    |> Floki.filter_out("translationstack")
    |> Floki.find("count")
    |> FlokiUtils.get_integer
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
