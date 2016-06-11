defmodule FASTA do
  def parse(fasta_string) do
    str = String.strip(fasta_string)

    Regex.split(fasta_separator_regex, str)
    |> Enum.map(&parse_datum/1)
  end

  defp parse_datum(datum_string) do
    [header_string, sequence_string] = Regex.split(~r/\n/, datum_string, parts: 2)

    header_str = clean_header(header_string)
    sequence_str = clean_sequence(sequence_string)

    %FASTA.Datum{header: header_str, sequence: sequence_str}
  end

  defp clean_header(raw_header) do
    raw_header
    |> String.lstrip(?>)
    |> String.strip
  end

  defp clean_sequence(raw_sequence) do
    Regex.replace(~r/\s+/, raw_sequence, "")
  end

  defp fasta_separator_regex do
    ~r/\s+>/
  end
end
