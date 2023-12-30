🌏 CharsetDetect: Guess character encoding for Elixir
=====================================================

[![Hex.pm](https://img.shields.io/hexpm/v/charset_detect.svg)](https://hex.pm/packages/charset_detect)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/charset_detect/)
[![Hex.pm](https://img.shields.io/hexpm/dt/charset_detect.svg)](https://hex.pm/packages/charset_detect)
[![License](https://img.shields.io/hexpm/l/charset_detect.svg)](https://github.com/ryochin/charset_detect/blob/main/LICENSE)

CharsetDetect is a simple wrapper around the [chardetng](https://crates.io/crates/chardetng) crate.

Usage
-----

Guess the encoding of a string:

```elixir
iex> File.read!("test/assets/sjis.txt") |> CharsetDetect.guess
{:ok, "Shift_JIS"}

iex> File.read!("test/assets/big5.txt") |> CharsetDetect.guess!
"Big5"
```

You might consider minimizing additional memory consumption.

```elixir
"... (long text) ..." |> String.slice(0, 1024) |> CharsetDetect.guess
```

Note that an ASCII string, including an empty string, will result in a `UTF-8` encoding rather than `ASCII`.

```elixir
iex> "hello world" |> CharsetDetect.guess
{:ok, "UTF-8"}
```

Strategies for implementing a conversion function
-------------------------------------------------

You can achieve conversion to any desired encoding using [iconv](https://hex.pm/packages/iconv).

```elixir
defmodule Converter do
  def convert(text, to_encoding \\ "UTF-8") do
    case text |> CharsetDetect.guess do
      {:ok, ^to_encoding} ->
        {:ok, text}
      {:ok, encoding} ->
        try do
          {:ok, :iconv.convert(encoding, to_encoding, text)}
        rescue
          e in ArgumentError -> {:error, inspect(e)}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end
end
```
```elixir
iex> File.read!("test/assets/big5.txt") |> Converter.convert
{:ok, "大五碼是繁体中文（正體中文）社群最常用的電腦漢字字符集標準。\n"}
```

Installation
------------

The package can be installed by adding `charset_detect` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:charset_detect, "~> 0.1.0"}
  ]
end
```

Then, run `mix deps.get`.

Development
-----------

### Prerequisites

**Note:** This library requires the [Rust](https://www.rust-lang.org/) Toolchain for compilation.

Follow the instructions at [www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install) to install Rust.

Verify the installation by checking the `cargo` command version:

```sh
cargo --version
# Should output something like: cargo 1.68.1 (115f34552 2023-02-26)
```

Then, set the `RUSTLER_PRECOMPILATION_EXAMPLE_BUILD` environment variable to ensure that local sources are compiled instead of downloading a precompiled library file.

```sh
RUSTLER_PRECOMPILATION_EXAMPLE_BUILD=1 mix compile
```

License
-------

The MIT License
