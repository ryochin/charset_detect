defmodule CharsetDetect do
  @moduledoc """
  CharsetDetect is a simple wrapper around the chardetng crate.
  """

  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :charset_detect,
    crate: "charset_detect",
    base_url: "https://github.com/ryochin/charset_detect/releases/download/v#{version}",
    force_build: System.get_env("RUSTLER_PRECOMPILATION_EXAMPLE_BUILD") in ["1", "true"],
    version: version

  @doc """
  Guess the encoding of a string.

  ## Examples

      iex> File.read!("test/assets/sjis.txt") |> CharsetDetect.guess
      {:ok, "Shift_JIS"}
  """
  @spec guess(binary) :: {:ok, String.t()} | {:error, String.t()}
  def guess(body) when is_binary(body) do
    case _guess(body) do
      result when is_binary(result) -> {:ok, result}
      {:error, reason} -> {:error, reason}
    end
  end

  def guess(_), do: {:error, "invalid argument"}

  @doc """
  Guess the encoding of a string (exceptional).

  ## Examples

      iex> File.read!("test/assets/big5.txt") |> CharsetDetect.guess!
      "Big5"
  """
  @spec guess!(binary) :: String.t()
  def guess!(body) when is_binary(body) do
    {:ok, result} = guess(body)

    result
  end

  # NIF function definition
  @spec _guess(binary) :: String.t() | {:error, String.t()}
  def _guess(_body), do: :erlang.nif_error(:nif_not_loaded)
end
