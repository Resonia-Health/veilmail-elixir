defmodule VeilMail.Emails do
  @moduledoc """
  Email sending and management.
  """

  alias VeilMail.Client

  @doc """
  Send a single email.

  ## Example

      {:ok, email} = VeilMail.Emails.send(client, %{
        from: "hello@yourdomain.com",
        to: ["user@example.com"],
        subject: "Hello!",
        html: "<p>Welcome!</p>"
      })
  """
  @spec send(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def send(%Client{} = client, params) do
    Client.post(client, "/v1/emails", params)
  end

  @doc """
  Send a batch of up to 100 emails.

  ## Example

      {:ok, result} = VeilMail.Emails.send_batch(client, [
        %{from: "hi@yourdomain.com", to: ["user1@example.com"], subject: "Hi", html: "<p>Hi!</p>"},
        %{from: "hi@yourdomain.com", to: ["user2@example.com"], subject: "Hi", html: "<p>Hi!</p>"}
      ])
  """
  @spec send_batch(Client.t(), [map()]) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def send_batch(%Client{} = client, emails) do
    Client.post(client, "/v1/emails/batch", %{emails: emails})
  end

  @doc """
  List emails with optional query parameters.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/emails", params)
  end

  @doc """
  Get a single email by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    Client.get(client, "/v1/emails/#{id}")
  end

  @doc """
  Cancel a scheduled email.
  """
  @spec cancel(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def cancel(%Client{} = client, id) do
    Client.post(client, "/v1/emails/#{id}/cancel")
  end

  @doc """
  Reschedule a scheduled email.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    Client.patch(client, "/v1/emails/#{id}", params)
  end

  @doc """
  Get tracked link analytics for a specific email.
  """
  @spec links(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def links(%Client{} = client, id, params \\ []) do
    Client.get(client, "/v1/emails/#{id}/links", params)
  end
end
