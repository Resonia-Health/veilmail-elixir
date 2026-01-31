defmodule VeilMail.Properties do
  @moduledoc """
  Contact property management.
  """

  alias VeilMail.Client

  @doc """
  Create a new property definition.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    with {:ok, response} <- Client.post(client, "/v1/properties", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  List all property definitions.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/properties", params)
  end

  @doc """
  Get a property definition by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    with {:ok, response} <- Client.get(client, "/v1/properties/#{id}") do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Update a property definition.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    with {:ok, response} <- Client.patch(client, "/v1/properties/#{id}", params) do
      {:ok, unwrap_data(response)}
    end
  end

  @doc """
  Delete a property definition.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/properties/#{id}")
  end

  @doc """
  Get property values for a subscriber.
  """
  @spec get_values(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def get_values(%Client{} = client, audience_id, subscriber_id) do
    Client.get(
      client,
      "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/properties"
    )
  end

  @doc """
  Set property values for a subscriber.
  """
  @spec set_values(Client.t(), String.t(), String.t(), map()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def set_values(%Client{} = client, audience_id, subscriber_id, values) do
    Client.put(
      client,
      "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/properties",
      values
    )
  end

  defp unwrap_data(%{"data" => data}) when is_map(data), do: data
  defp unwrap_data(response), do: response
end
