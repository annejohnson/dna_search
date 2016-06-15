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
```

[View full documentation here](https://hexdocs.pm/dna_search/api-reference.html).

## TODO

- Write tests for enforcement of max_limit
- Don't make real API calls during tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/annejohnson/dna_search. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
