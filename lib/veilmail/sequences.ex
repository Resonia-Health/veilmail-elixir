defmodule VeilMail.Sequences do
  @moduledoc """
  Automation sequence management.
  """

  alias VeilMail.Client

  @doc """
  Create a new automation sequence.
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def create(%Client{} = client, params) do
    Client.post(client, "/v1/sequences", params)
  end

  @doc """
  List all automation sequences.
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/v1/sequences", params)
  end

  @doc """
  Get a sequence by ID.
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def get(%Client{} = client, id) do
    Client.get(client, "/v1/sequences/#{id}")
  end

  @doc """
  Update a sequence (only DRAFT or PAUSED).
  """
  @spec update(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def update(%Client{} = client, id, params) do
    Client.put(client, "/v1/sequences/#{id}", params)
  end

  @doc """
  Delete a sequence (only DRAFT).
  """
  @spec delete(Client.t(), String.t()) :: :ok | {:error, VeilMail.Error.t()}
  def delete(%Client{} = client, id) do
    Client.delete(client, "/v1/sequences/#{id}")
  end

  @doc """
  Activate a sequence.
  """
  @spec activate(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def activate(%Client{} = client, id) do
    Client.post(client, "/v1/sequences/#{id}/activate")
  end

  @doc """
  Pause an active sequence.
  """
  @spec pause(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def pause(%Client{} = client, id) do
    Client.post(client, "/v1/sequences/#{id}/pause")
  end

  @doc """
  Archive a sequence.
  """
  @spec archive(Client.t(), String.t()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def archive(%Client{} = client, id) do
    Client.post(client, "/v1/sequences/#{id}/archive")
  end

  @doc """
  Add a step to a sequence.
  """
  @spec add_step(Client.t(), String.t(), map()) :: {:ok, map()} | {:error, VeilMail.Error.t()}
  def add_step(%Client{} = client, sequence_id, params) do
    Client.post(client, "/v1/sequences/#{sequence_id}/steps", params)
  end

  @doc """
  Update a sequence step.
  """
  @spec update_step(Client.t(), String.t(), String.t(), map()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def update_step(%Client{} = client, sequence_id, step_id, params) do
    Client.put(client, "/v1/sequences/#{sequence_id}/steps/#{step_id}", params)
  end

  @doc """
  Delete a sequence step.
  """
  @spec delete_step(Client.t(), String.t(), String.t()) ::
          :ok | {:error, VeilMail.Error.t()}
  def delete_step(%Client{} = client, sequence_id, step_id) do
    Client.delete(client, "/v1/sequences/#{sequence_id}/steps/#{step_id}")
  end

  @doc """
  Reorder sequence steps.
  """
  @spec reorder_steps(Client.t(), String.t(), list(map())) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def reorder_steps(%Client{} = client, sequence_id, steps) do
    Client.post(client, "/v1/sequences/#{sequence_id}/steps/reorder", %{steps: steps})
  end

  @doc """
  Enroll subscribers into a sequence.
  """
  @spec enroll(Client.t(), String.t(), list(String.t())) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def enroll(%Client{} = client, sequence_id, subscriber_ids) do
    Client.post(client, "/v1/sequences/#{sequence_id}/enroll", %{
      subscriberIds: subscriber_ids
    })
  end

  @doc """
  List enrollments for a sequence.
  """
  @spec list_enrollments(Client.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, VeilMail.Error.t()}
  def list_enrollments(%Client{} = client, sequence_id, params \\ []) do
    Client.get(client, "/v1/sequences/#{sequence_id}/enrollments", params)
  end

  @doc """
  Remove an enrollment from a sequence.
  """
  @spec remove_enrollment(Client.t(), String.t(), String.t()) ::
          :ok | {:error, VeilMail.Error.t()}
  def remove_enrollment(%Client{} = client, sequence_id, enrollment_id) do
    Client.delete(
      client,
      "/v1/sequences/#{sequence_id}/enrollments/#{enrollment_id}"
    )
  end
end
