defmodule FASTA do
  def get_sequence(%{sequence: seq}), do: seq
  def get_sequence(_), do: nil

  def get_header(%{header: header_str}), do: header_str
  def get_header(_), do: nil

  def parse(fasta_string) do
    Regex.split(fasta_separator_regex, fasta_string)
    |> Enum.map(&parse_datum/1)
  end

  def parse_datum(datum_string) do
    [header_string, sequence_string] = Regex.split(~r/\n/, datum_string, parts: 2)
    header_data = parse_header(header_string)
    sequence_data = parse_sequence(sequence_string)
    Map.merge(header_data, sequence_data)
  end

  def parse_header(raw_header) do
    %{header: clean_header(raw_header)}
  end

  def parse_sequence(raw_sequence) do
    %{sequence: clean_sequence(raw_sequence)}
  end

  def clean_header(raw_header) do
    raw_header
    |> String.lstrip(?>)
    |> String.strip
  end

  def clean_sequence(raw_sequence) do
    Regex.replace(~r/\s+/, raw_sequence, "")
  end

  def fasta_separator_regex do
    ~r/\s+>/
  end
end
