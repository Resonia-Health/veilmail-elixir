defmodule VeilMail.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/Resonia-Health/veilmail-elixir"

  def project do
    [
      app: :veilmail,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Official Elixir SDK for the Veil Mail email API",
      docs: docs(),
      source_url: @source_url,
      homepage_url: "https://veilmail.xyz"
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "veilmail",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Documentation" => "https://veilmail.xyz/docs/sdk-elixir"
      }
    ]
  end

  defp docs do
    [
      main: "VeilMail",
      source_url: @source_url,
      groups_for_modules: [
        Resources: [
          VeilMail.Emails,
          VeilMail.Domains,
          VeilMail.Templates,
          VeilMail.Audiences,
          VeilMail.Campaigns,
          VeilMail.Webhooks,
          VeilMail.Topics,
          VeilMail.Properties
        ],
        Core: [VeilMail.Client, VeilMail.Error],
        Utilities: [VeilMail.Webhook]
      ]
    ]
  end
end
