defmodule VeilMail.Topics do
  @moduledoc """
  Subscription topic management.
  """

  alias VeilMail.Client

  @doc """
  Create a new topic.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    Client.post(client, "/v1/topics", params)
  end

  @doc """
  List all topics.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/topics", params)
  end

  @doc """
  Get a topic by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    Client.get(client, "/v1/topics/#{id}")
  end

  @doc """
  Update a topic.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    Client.patch(client, "/v1/topics/#{id}", params)
  end

  @doc """
  Delete a topic.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/topics/#{id}")
  end

  @doc """
  Get a subscriber's topic preferences.
  """
  @spec get_preferences(Client.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def get_preferences(%Client{} = client, audience_id, subscriber_id) do
    Client.get(
      client,
      "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/topics"
    )
  end

  @doc """
  Set a subscriber's topic preferences.
  """
  @spec set_preferences(Client.t(), String.t(), String.t(), map()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def set_preferences(%Client{} = client, audience_id, subscriber_id, params) do
    Client.put(
      client,
      "/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/topics",
      params
    )
  end
end
