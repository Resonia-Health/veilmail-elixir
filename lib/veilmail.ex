defmodule VeilMail do
  @moduledoc """
  Official Elixir SDK for the Veil Mail API.

  ## Quick Start

      client = VeilMail.client("veil_live_xxxxx")

      {:ok, email} = VeilMail.Emails.send(client, %{
        from: "hello@yourdomain.com",
        to: ["user@example.com"],
        subject: "Hello from Elixir!",
        html: "<h1>Welcome!</h1>"
      })

  ## Configuration

      client = VeilMail.client("veil_live_xxxxx",
        base_url: "https://custom-api.example.com",
        timeout: 10_000
      )
  """

  @doc """
  Create a new VeilMail client.

  ## Options

    * `:base_url` - Custom API base URL (default: `https://api.veilmail.xyz`)
    * `:timeout` - Request timeout in milliseconds (default: `30_000`)

  ## Examples

      client = VeilMail.client("veil_live_xxxxx")
      client = VeilMail.client("veil_live_xxxxx", base_url: "https://custom.example.com")
  """
  @spec client(String.t(), keyword()) :: VeilMail.Client.t()
  def client(api_key, opts \\ []) do
    VeilMail.Client.new(api_key, opts)
  end
end
