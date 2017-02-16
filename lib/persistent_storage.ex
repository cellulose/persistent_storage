defmodule PersistentStorage do

  @moduledoc """
  Stores and retrieves terms from small flat files on embedded systems.

  `PersistentStorage` is intended for trivial persistent storage of basic system
  and application configuration information on embedded systems.   It is not
  intended to be a replacement for dets, sqlite, or many other far more capable
  databases.  It favors simplicity and robustness over performance and
  capability.

  ## Configuration

  Define one or more storage areas in your config.exs as follows...

  ```elixir
  # my_app/config/config.exs
  ...
  config :persistent_storage, tables: [
    settings: [path: "/root/storage/settings"],
    provisioning: [path: "/boot/provisioning"]
  ]
  ```

  The `:path` option is required is used to specify the filesystem path where
  files will be written.

  ## Usage

  ```elixir
  # write to settings (this will create the file at
  # /root/storage/settings/network
  iex> PersistentStorage.put :settings, :network, %{
    ip_address: {192,168,1,100}, mode: :static
  }

  # later, we can read it (this reads from ets cache if possible)
  iex> PersistentStorage.get :settings, :network
  %{ip_address: {192,168,1,100}, mode: :static}

  # read some provisioning data -- for purposes of this example, we
  # assume it was written when device  was first flashed)
  iex> PersistentStorage.get :provisioning, :device_data
  [serial_number: "302F1010", mfg_timestamp: "2016-05-04T03:28:35.279977Z"]
  ```
  """

  @type table :: atom
  @type key :: atom
  @type value :: any
  @type posix :: :file.posix

  # setup module attribute based on application env at compile time to allow
  # configuration of this module by applications that use it

  @tables Application.get_env :persistent_storage, :tables, []

  @doc """
  OTP Application start callback.

  Starts a supervisor with only one child process to own ETS tables.
  """
  @spec start(atom, term) :: {:ok, pid} | {:error, String.t}
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [ worker(__MODULE__, []) ]
    Supervisor.start_link children, [strategy: :one_for_one, name: PersistentStorage.Supervisor]
  end

  @doc false
  @spec start_link() :: {:ok, pid()}
  def start_link do
    pid = spawn_link fn ->
      for {table, _opts} <- @tables do
        table_id = ets_table_for(table)
        ^table_id = :ets.new table_id, [ :set, :public, :named_table ]
      end
      receive do
        after :infinity -> :ok
      end
    end
    {:ok, pid}
  end

  @doc """
  Puts a single key and its associated value into storage.

  This is simple syntactic sugar for put/3 to allow specifying arguments
  with a keyword list consisting of a single key/value pair.

  ## Example

  ```elixir
  PersistentStorage.put :network_settings, router_ip_address: {192,168,15,1}
  ```
  """
  @spec put(table, [{key, value}]) :: :ok | {:error, posix}
  def put(table, [{key, value}]), do: put(table, key, value)

  @doc """
  Put a single key and its associated value into storage.

  ## Example

  ```elixir
  PersistentStorage.put :network_settings, :router_ip_address, {192,168,15,1}
  ```
  """
  @spec put(table, key, value) :: :ok | {:error, posix}
  def put(table, key, term) do
    :ets.insert ets_table_for(table), [{key, term}]
    case File.mkdir_p(directory_for(table)) do
      :ok ->
        File.write(path_for(table, key), :erlang.term_to_binary(term))
      error ->
        error
    end
  end

  @doc """
  Return the value associated with the given key in the specified storage.

  If the storage storage does not contain a key, returns the value of `default`
  (or nil if `default` is not provided).

  Uses the ets cache if possible, otherwise reads from disk.

  ## Examples

  ```elixir
  PersistentStorage.get :network_settings, :router_ip_address
  PersistentStorage.get :network_settings, :router_ip_address, {0,0,0,0}
  ```
  """
  @spec get(table, key, any) :: any
  def get(table, key, default_value \\ nil) do
    case :ets.lookup(ets_table_for(table), key) do
      [{^key, value}] ->
        value
      _ -> # not in ets cache
        case File.read(path_for(table, key)) do
          {:ok, contents} when (contents != "") ->
            term = :erlang.binary_to_term(contents)
            :ets.insert ets_table_for(table), [{key, term}]
            term
          _ ->
            default_value
        end
    end
  end

  @doc """
  Removes an entry from storage.

  ```elixir
  PersistentStorage.delete :network_settings, :router_ip_address
  ```
  """
  @spec delete(table, key) :: :ok
  def delete(table, key) do
    :ets.delete(ets_table_for(table), key)
    case File.rm(path_for(table, key)) do
      {:error, :enoent} ->
        :ok
      other ->
        other
    end
  end


  ### private helpers

  # returns the ets table for the specified storage
  defp ets_table_for(table), do: :"persistent_storage.#{table}"

  # return a directory given a storage name
  defp directory_for(table), do: @tables[table][:path]

  # given a storage and key, return a file path
  defp path_for(table, key) do
    Path.join directory_for(table), "#{key}.storage"
  end
end
