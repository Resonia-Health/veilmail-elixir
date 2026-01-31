defmodule VeilMail.Campaigns do
  @moduledoc """
  Campaign management.
  """

  alias VeilMail.Client

  @doc """
  Create a new campaign.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    with {:ok, response} <- Client.post(client, "/v1/campaigns", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List all campaigns.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/campaigns", params)
  end

  @doc """
  Get a campaign by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    with {:ok, response} <- Client.get(client, "/v1/campaigns/#{id}") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update a campaign.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    with {:ok, response} <- Client.patch(client, "/v1/campaigns/#{id}", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Delete a campaign.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/campaigns/#{id}")
  end

  @doc """
  Schedule a campaign for sending.
  """
  @spec schedule(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def schedule(%Client{} = client, id, params) do
    with {:ok, response} <-
           Client.post(client, "/v1/campaigns/#{id}/schedule", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Send a campaign immediately.
  """
  @spec send_now(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def send_now(%Client{} = client, id) do
    with {:ok, response} <- Client.post(client, "/v1/campaigns/#{id}/send") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Pause a sending campaign.
  """
  @spec pause(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def pause(%Client{} = client, id) do
    with {:ok, response} <- Client.post(client, "/v1/campaigns/#{id}/pause") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Resume a paused campaign.
  """
  @spec resume(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def resume(%Client{} = client, id) do
    with {:ok, response} <- Client.post(client, "/v1/campaigns/#{id}/resume") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Cancel a campaign.
  """
  @spec cancel(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def cancel(%Client{} = client, id) do
    with {:ok, response} <- Client.post(client, "/v1/campaigns/#{id}/cancel") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Send a test/preview of a campaign.
  """
  @spec send_test(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def send_test(%Client{} = client, id, params) do
    Client.post(client, "/v1/campaigns/#{id}/test", params)
  end

  @doc """
  Clone a campaign as a new draft.
  """
  @spec clone(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def clone(%Client{} = client, id, options \\ %{}) do
    Client.post(client, "/v1/campaigns/#{id}/clone", options)
  end

  @doc """
  Get tracked link analytics for a campaign.
  """
  @spec links(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def links(%Client{} = client, id, params \\ []) do
    Client.get(client, "/v1/campaigns/#{id}/links", params)
  end

  defp unwrap_data(%{"data" => data}) when is_map(data), do: data
  defp unwrap_data(response), do: response
end
