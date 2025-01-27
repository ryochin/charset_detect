defmodule CharsetDetect.MixProject do
  use Mix.Project

  @version "0.1.3"

  def project do
    [
      app: :charset_detect,
      version: @version,
      elixir: "~> 1.14",
      build_embedded: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "CharsetDetect",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.10", only: :dev},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:iconv, "~> 1.0", only: :dev},
      {:rustler_precompiled, "~> 0.8"},
      {:rustler, "~> 0.30", optional: true}
    ]
  end

  defp description do
    "Guess character encoding"
  end

  defp package do
    [
      maintainers: ["Ryo Okamoto"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ryochin/charset_detect"},
      files: ~w(mix.exs README.md lib native test LICENSE checksum-*.exs .formatter.exs)
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/ryochin/charset_detect"
    ]
  end
end
