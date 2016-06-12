ExUnit.start()

defmodule DNASearchTestHelper do
  def valid_fasta_string?(str) do
    str =~ ~r/\A>[^\n]+\n[#{nucleotide_codes}]+/
  end

  def valid_sequence?(str) do
    str =~ ~r/\A[#{nucleotide_codes}\-]+\Z/i
  end

  defp nucleotide_codes do
    "ACGTURYKMSWBDHVN"
  end
end
