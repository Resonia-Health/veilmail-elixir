defmodule VeilMail.Feeds do
  @moduledoc """
  RSS feed management.
  """

  alias VeilMail.Client

  @doc """
  Create a new RSS feed.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    Client.post(client, "/v1/feeds", params)
  end

  @doc """
  List all RSS feeds.
  """
  @spec list(Client.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client) do
    Client.get(client, "/v1/feeds")
  end

  @doc """
  Get a feed by ID (includes recent items).
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    Client.get(client, "/v1/feeds/#{id}")
  end

  @doc """
  Update a feed.
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    Client.put(client, "/v1/feeds/#{id}", params)
  end

  @doc """
  Delete a feed and all its items.
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/feeds/#{id}")
  end

  @doc """
  Manually trigger a feed poll.
  """
  @spec poll(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def poll(%Client{} = client, id) do
    Client.post(client, "/v1/feeds/#{id}/poll")
  end

  @doc """
  Pause an active feed.
  """
  @spec pause(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def pause(%Client{} = client, id) do
    Client.post(client, "/v1/feeds/#{id}/pause")
  end

  @doc """
  Resume a paused or errored feed.
  """
  @spec resume(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def resume(%Client{} = client, id) do
    Client.post(client, "/v1/feeds/#{id}/resume")
  end

  @doc """
  List feed items with pagination.
  """
  @spec list_items(Client.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def list_items(%Client{} = client, feed_id, params \\ []) do
    Client.get(client, "/v1/feeds/#{feed_id}/items", params)
  end
end
