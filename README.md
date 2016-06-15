# DNASearch [![Hex.pm](https://img.shields.io/hexpm/v/dna_search.svg?style=flat-square)](https://hex.pm/packages/dna_search)

This is a tool for looking up DNA sequences by species in Elixir.

## Installation

Add `DNASearch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:dna_search, "~> 0.0.1"}]
end
```

## Usage

```elixir
iex> DNASearch.get_sequences("Pionus maximiliani", limit: 1)
["CGCGAAACAGGTGTCTCTTGGTTCCGACTGACCTGTGCTTTTATGAGCTTGTTGGTTTAGTTAGTTTGTTGGGGGTTGTTGGGTTTTGGGTTTGGGTTTTTTTCCTCCTTTTCTAGACACATATTTTTGACAGGCTGTATAAAACTTTACTTATCTTTGTTAATAATGTAGCTTTGAACTACTTATTCTGACATTCCAGATCAGCTTTAATGGAAGTGAAGGGAGGCGAAGTAGGAGTAGAAGATACTCTGGATCTGATAGTGACTCTATCTCGGAAAGGAAACGGCCAAAAAAGCGTGGAAGACCACGAACTATTCCTCGAGAAAATATT"]


iex> DNASearch.get_fasta_data("Pionus maximiliani", limit: 1)
[
  %FASTA.Datum{
    header: "gi|925719343|gb|KR019962.1| Pionus maximiliani voucher PMAX-COESP chromo-helicase-DNA binding protein-Z (CHDZ) gene, exons 23, 24 and partial cds",
    sequence: "CGCGAAACAGGTGTCTCTTGGTTCCGACTGACCTGTGCTTTTATGAGCTTGTTGGTTTAGTTAGTTTGTTGGGGGTTGTTGGGTTTTGGGTTTGGGTTTTTTTCCTCCTTTTCTAGACACATATTTTTGACAGGCTGTATAAAACTTTACTTATCTTTGTTAATAATGTAGCTTTGAACTACTTATTCTGACATTCCAGATCAGCTTTAATGGAAGTGAAGGGAGGCGAAGTAGGAGTAGAAGATACTCTGGATCTGATAGTGACTCTATCTCGGAAAGGAAACGGCCAAAAAAGCGTGGAAGACCACGAACTATTCCTCGAGAAAATATT"
  }
]
```

[View full documentation here](https://hexdocs.pm/dna_search/api-reference.html).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/annejohnson/dna_search. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
