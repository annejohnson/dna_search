defmodule FASTATest do
  use ExUnit.Case
  doctest FASTA

  defp header1 do
    "Locus5|ncbi Polytelis swainsonii"
  end

  defp header2 do
    "Locus8|ncbi Pionus maximiliani"
  end

  defp sequence1 do
    "ATCGTAGTCTGAGTCATGA\nTGCTAGTCAGTTAGTCAGTAGC"
  end

  defp sequence2 do
    "TCGTCGTAAAAATGC"
  end

  test "parse extracts data from a valid fasta string" do
    raw_valid_fastas = [
      ">#{header1}\n#{sequence1}\n\n> #{header2}\n#{sequence2}",
      "\n>#{header1}\n\n#{sequence1}\n\n> #{header2}\n#{sequence2}\n"
    ]

    Enum.map(raw_valid_fastas, fn(raw_fasta) ->
      [first_datum, second_datum] = FASTA.parse(raw_fasta)

      assert(first_datum.header == header1)
      assert(first_datum.sequence == Regex.replace(~r/\s+/, sequence1, ""))

      assert(second_datum.header == header2)
      assert(second_datum.sequence == Regex.replace(~r/\s+/, sequence2, ""))
    end)
  end

  test "parse returns an empty list of data from an invalid fasta string" do
    raw_invalid_fasta = "> #{header1}\n> #{header2}"
    fasta_data = FASTA.parse(raw_invalid_fasta)

    assert(Enum.empty?(fasta_data))
  end
end
