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
    raw_fasta = ">#{header1}
                 #{sequence1}

                 > #{header2}
                 #{sequence2}"
    fasta_data = FASTA.parse(raw_fasta)

    assert(length(fasta_data) == 2)

    [first_datum, second_datum] = fasta_data

    assert(first_datum.header == header1)
    assert(first_datum.sequence == Regex.replace(~r/\s+/, sequence1, ""))

    assert(second_datum.header == header2)
    assert(second_datum.sequence == Regex.replace(~r/\s+/, sequence2, ""))
  end

  test "parse extracts data from a valid fasta string with strange spacing" do
    raw_fasta = "
                 >#{header1}

                 #{sequence1}

                 > #{header2}
                 #{sequence2}

                 "
    fasta_data = FASTA.parse(raw_fasta)

    assert(length(fasta_data) == 2)

    [first_datum, second_datum] = fasta_data

    assert(first_datum.header == header1)
    assert(first_datum.sequence == Regex.replace(~r/\s+/, sequence1, ""))

    assert(second_datum.header == header2)
    assert(second_datum.sequence == Regex.replace(~r/\s+/, sequence2, ""))
  end

  test "parse returns an empty list of data from an invalid fasta string" do
    raw_invalid_fasta = "> #{header1}
                         > #{header2}"
    fasta_data = FASTA.parse(raw_invalid_fasta)

    assert(Enum.empty?(fasta_data))
  end
end
