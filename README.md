# VeilMail Elixir SDK

The official Elixir SDK for the [Veil Mail](https://veilmail.xyz) email API.

## Installation

Add `veilmail` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:veilmail, "~> 0.1.0"}
  ]
end
```

## Quick Start

```elixir
client = VeilMail.client("veil_live_xxxxx")

{:ok, email} = VeilMail.Emails.send(client, %{
  from: "hello@yourdomain.com",
  to: ["user@example.com"],
  subject: "Hello from Elixir!",
  html: "<h1>Welcome!</h1>"
})

IO.inspect(email)
```

## Configuration

```elixir
client = VeilMail.client("veil_live_xxxxx",
  base_url: "https://custom-api.example.com",
  timeout: 10_000
)
```

## Resources

| Module | Description |
|--------|-------------|
| `VeilMail.Emails` | Send, batch send, list, get, cancel, update |
| `VeilMail.Domains` | Create, verify, update, list, delete |
| `VeilMail.Templates` | Create, update, preview, list, delete |
| `VeilMail.Audiences` | Manage audiences and subscribers |
| `VeilMail.Campaigns` | Create, schedule, send, pause, resume, cancel |
| `VeilMail.Webhooks` | Manage endpoints, test, rotate secrets |
| `VeilMail.Topics` | Manage subscription topics and preferences |
| `VeilMail.Properties` | Manage contact property definitions and values |

## Sending Emails

```elixir
# Simple send
{:ok, email} = VeilMail.Emails.send(client, %{
  from: "hello@yourdomain.com",
  to: ["user@example.com"],
  subject: "Hello!",
  html: "<p>Hello World!</p>",
  tags: ["welcome"]
})

# With template
{:ok, email} = VeilMail.Emails.send(client, %{
  from: "hello@yourdomain.com",
  to: ["user@example.com"],
  templateId: "tmpl_xxx",
  templateData: %{name: "Alice"}
})

# Batch send (up to 100)
{:ok, result} = VeilMail.Emails.send_batch(client, [
  %{from: "hi@yourdomain.com", to: ["user1@example.com"], subject: "Hi", html: "<p>Hi!</p>"},
  %{from: "hi@yourdomain.com", to: ["user2@example.com"], subject: "Hi", html: "<p>Hi!</p>"}
])
```

## Subscriber Management

```elixir
# Add a subscriber
{:ok, subscriber} = VeilMail.Audiences.add_subscriber(client, "audience_xxxxx", %{
  email: "user@example.com",
  firstName: "Alice",
  lastName: "Smith"
})

# List subscribers
{:ok, result} = VeilMail.Audiences.list_subscribers(client, "audience_xxxxx",
  limit: "50",
  status: "active"
)

# Export as CSV
{:ok, csv} = VeilMail.Audiences.export_subscribers(client, "audience_xxxxx")
```

## Error Handling

```elixir
case VeilMail.Emails.send(client, params) do
  {:ok, email} ->
    IO.puts("Sent: #{email["id"]}")

  {:error, %VeilMail.Error{type: :authentication, message: message}} ->
    IO.puts("Invalid API key: #{message}")

  {:error, %VeilMail.Error{type: :pii_detected, pii_types: types}} ->
    IO.puts("PII detected: #{inspect(types)}")

  {:error, %VeilMail.Error{type: :rate_limit, retry_after: retry}} ->
    IO.puts("Rate limited, retry after #{retry} seconds")

  {:error, %VeilMail.Error{type: :validation, message: message, details: details}} ->
    IO.puts("Validation: #{message} (#{inspect(details)})")

  {:error, %VeilMail.Error{message: message}} ->
    IO.puts("Error: #{message}")
end
```

## Webhook Verification

```elixir
case VeilMail.Webhook.verify(body, signature, "whsec_xxxxx") do
  {:ok, payload} ->
    case payload["type"] do
      "email.delivered" -> handle_delivered(payload["data"])
      "email.bounced" -> handle_bounced(payload["data"])
      _ -> :ok
    end

  {:error, :invalid_signature} ->
    {:error, :unauthorized}
end
```

### Phoenix Controller Example

```elixir
defmodule MyAppWeb.WebhookController do
  use MyAppWeb, :controller

  @webhook_secret "whsec_xxxxx"

  def handle(conn, _params) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    signature = Plug.Conn.get_req_header(conn, "x-signature-hash") |> List.first("")

    case VeilMail.Webhook.verify(body, signature, @webhook_secret) do
      {:ok, payload} ->
        process_event(payload)
        send_resp(conn, 200, "OK")

      {:error, _reason} ->
        send_resp(conn, 401, "Invalid signature")
    end
  end

  defp process_event(%{"type" => "email.delivered", "data" => data}) do
    IO.inspect(data, label: "Delivered")
  end

  defp process_event(%{"type" => "email.bounced", "data" => data}) do
    IO.inspect(data, label: "Bounced")
  end

  defp process_event(_event), do: :ok
end
```

## License

MIT
