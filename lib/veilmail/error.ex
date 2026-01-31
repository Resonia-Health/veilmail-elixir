defmodule VeilMail.Error do
  @moduledoc """
  Error struct returned by VeilMail API operations.
  """

  @type error_type ::
          :authentication
          | :forbidden
          | :not_found
          | :validation
          | :pii_detected
          | :rate_limit
          | :server
          | :http
          | :unknown

  @type t :: %__MODULE__{
          type: error_type(),
          message: String.t(),
          status: non_neg_integer() | nil,
          code: String.t() | nil,
          details: map() | nil,
          pii_types: [String.t()] | nil,
          retry_after: non_neg_integer() | nil
        }

  defexception [:type, :message, :status, :code, :details, :pii_types, :retry_after]

  @impl true
  def message(%__MODULE__{message: message}), do: message

  @doc false
  def from_response(status, body) when is_map(body) do
    error = Map.get(body, "error", body)
    message = get_in_any(error, ["message"]) || "Unknown error"
    code = get_in_any(error, ["code"])

    case status do
      401 ->
        %__MODULE__{type: :authentication, message: message, status: 401, code: code}

      403 ->
        %__MODULE__{type: :forbidden, message: message, status: 403, code: code}

      404 ->
        %__MODULE__{type: :not_found, message: message, status: 404, code: code}

      400 ->
        details = get_in_any(error, ["details"])

        %__MODULE__{
          type: :validation,
          message: message,
          status: 400,
          code: code,
          details: details
        }

      422 ->
        pii_types = get_in_any(error, ["piiTypes"]) || []

        if code == "pii_detected" or pii_types != [] do
          %__MODULE__{
            type: :pii_detected,
            message: message,
            status: 422,
            code: code,
            pii_types: pii_types
          }
        else
          %__MODULE__{type: :validation, message: message, status: 422, code: code}
        end

      429 ->
        retry_after = get_in_any(error, ["retryAfter"])

        %__MODULE__{
          type: :rate_limit,
          message: message,
          status: 429,
          code: code,
          retry_after: retry_after
        }

      s when s >= 500 ->
        %__MODULE__{type: :server, message: message, status: s, code: code}

      _ ->
        %__MODULE__{type: :unknown, message: message, status: status, code: code}
    end
  end

  @doc false
  def from_exception(exception) do
    %__MODULE__{
      type: :http,
      message: Exception.message(exception),
      status: nil
    }
  end

  defp get_in_any(map, keys) when is_map(map) do
    Enum.find_value(keys, fn key -> Map.get(map, key) end)
  end

  defp get_in_any(_, _), do: nil
end
