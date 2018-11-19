defmodule ExDataHoover.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_data_hoover,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: "Simple API to implement event sourcing",
      deps: deps(),
      package: package()
    ]
  end

  def package do
    [
      maintainers: [" Jobteaser "],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jobteaser/ex_data_hoover"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
