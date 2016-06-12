defmodule DNASearch.NCBI do
  # API info: https://www.ncbi.nlm.nih.gov/books/NBK25500/
  # Fields info: http://www.ncbi.nlm.nih.gov/books/NBK49540/
  # Syntax info: https://www.ncbi.nlm.nih.gov/books/NBK25499/

  def get_fasta(organism_name) do
    organism_name
    |> get_sequence_ids
    |> get_fasta_for_sequence_ids
  end

  def get_sequence_ids(organism_name) do
    organism_name
    |> make_search_request
    |> Floki.find("idlist id")
    |> Enum.map(&Floki.FlatText.get/1)
  end

  def get_fasta_for_sequence_ids(id_strings) do
    id_strings
    |> make_fasta_request
  end

  defp make_search_request(query) do
    make_get_request(search_url, search_params(query))
  end

  defp make_fasta_request(sequence_ids) do
    make_get_request(fetch_url, fasta_params(sequence_ids))
  end

  defp search_params(query) do
    %{
      term: "#{query}[primary organism] AND biomol_genomic[prop]",
      retmax: max_records_per_request
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

  defp make_get_request(url_endpoint, params) do
    url = url_endpoint <> "?" <> URI.encode_query(params)
    HTTPotion.get(url, timeout: timeout_in_milliseconds).body
  end

  defp max_records_per_request do
    20
  end

  defp timeout_in_milliseconds do
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
