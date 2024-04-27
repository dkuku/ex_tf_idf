defmodule TfIdf.MixProject do
  use Mix.Project

  def project do
    [
      app: :tf_idf,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.32", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Calculate word rankings using tf_idf algorithm"
  end

  defp package() do
    [
      files: ~w(lib test mix.exs README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/dkuku/ex_tf_idf"}
    ]
  end
end
