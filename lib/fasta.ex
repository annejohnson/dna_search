defmodule FASTA do
  def get_sequence(fasta_datum) do
    fasta_datum.sequence
  end

  def parse(fasta_string) do
    Regex.split(fasta_separator_regex, fasta_string)
    |> Enum.map(&parse_datum/1)
  end

  def parse_datum(datum_string) do
    [metadata_string, sequence_string] = Regex.split(~r/\n/, datum_string, parts: 2)
    metadata = parse_metadata_string(metadata_string)
    sequence_data = parse_sequence_string(sequence_string)
    Map.merge(metadata, sequence_data)
  end

  def parse_metadata_string(metadata_string) do
    %{metadata: metadata_string} # TODO:
  end

  def parse_sequence_string(raw_sequence) do
    %{sequence: clean_sequence(raw_sequence)}
  end

  def clean_sequence(raw_sequence) do
    Regex.replace(~r/[^#{valid_sequence_characters}]/, raw_sequence, "")
  end

  def valid_sequence_characters do
    "ACGTURYKMSWBDHVN-"
  end

  def fasta_separator_regex do
    ~r/\s+>/
  end
end
