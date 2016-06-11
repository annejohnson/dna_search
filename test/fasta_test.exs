defmodule FASTATest do
  use ExUnit.Case
  doctest FASTA

  test "parse" do
    header1 = "Locus5|ncbi Polytelis swainsonii"
    sequence1 = "ATCGTAGTCTGAGTCATGATGCTAGTCAGTTAGTCAGTAGC"
    header2 = "Locus8|ncbi Pionus maximiliani"
    sequence2 = "TCGTCGTAAAAATGC"

    raw_fasta = ">#{header1}
                 #{sequence1}

                 > #{header2}
                 #{sequence2}"
    fasta_data = FASTA.parse(raw_fasta)

    assert(
      length(fasta_data) == 2
    )

    [first_datum, second_datum] = fasta_data
    assert(first_datum.header == header1)
    assert(first_datum.sequence == sequence1)
    assert(second_datum.header == header2)
    assert(second_datum.sequence == sequence2)
  end
end
