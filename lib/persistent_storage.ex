defmodule PersistentStorage do

  @moduledoc """
  Perisistently store erlang terms to the filesystem

  A trivial way to write simple stuff that you might need "next time you run".

  Implemented as a singleton -- you can only have one instance, for simplicity.

  Performance is good because although each term is stored as a file, the reads
  come from a cache, so there is no need to cache locally.

  ## Examples

  Setup PersistentStorage, including the path in the filesystem where files
  will be stored

      PersistentStorage.setup path: "/path/to/storage/area"

  Then, to store data you would:

      PersistentStorage.put :router_ip_address, {192,168,15,1}
      ...or...
      PersistentStorage.put router_ip_address: {192,168,15,1}

  Then, to retrieve the stored data:

      PersistentStorage.get :router_ip_address
  """
  @ets_table  :persistent_storage_cache
  @path_key   :__storage_path__

  @type key :: any
  @type value :: any
  @type t :: list | map
  @type posix :: :file.posix

  @doc """
  Sets up `ets_table` and path where persistent files will be written
  to persistent drive.

  ## Options

  The `:path` option is used to specify the filesystem path where files
  will be written. Default path is `/tmp`
  """
  @spec setup(t) :: :ok
  def setup(args \\ []) do
    path = Dict.get args, :path, "/tmp"
    File.mkdir_p! path
    :ets.new @ets_table, [:set, :public, :named_table]
    :ets.insert @ets_table, [{@path_key, path}]
    :ok
  end

  @doc """
  Put the value of each key passed into storage (keys must be atoms)

  ## Examples

      PersistentStorage.put router_ip_address: {192,168,15,1}
      PersistentStorage.put [store: :something, multiple: :this_time]

  """
  @spec put(t) :: :ok
  def put(dict) when is_list(dict) do
    Enum.map dict, fn({k,v}) -> put(k,v) end
    :ok
  end

  @doc """
  Put a single term into storage under a key (key must be an atom)

  ## Examples

      PersistentStorage.put :router_ip_address, {192,168,15,1}
  """
  @spec put(key, value) :: :ok
  def put(key, term) do
    :ets.insert @ets_table, [{key, term}]
    File.write key_to_file_path(key), :erlang.term_to_binary(term)
    :ok
  end

  @doc """
  Get value for the given key. If dict does not contain key, returns
  default (or nil if not provided).

  Uses cache if possible, otherwise reads from disk

  ## Examples

      PersistentStorage.get :router_ip_address
      PersistentStorage.get :router_ip_address, {0,0,0,0}
  """
  @spec get(key, value) :: value
  def get(key, default \\ nil) do
    case :ets.lookup(@ets_table, key) do
      [{^key, value}] -> value
      _ -> get_from_persistent_storage(key, default)
    end
  end

  @doc """
  Removes keys in dictionary from table and persistent drive
  """
  @spec delete(t) :: :ok
  def delete(dict) when is_list(dict) do
    Enum.map(dict, fn(k) -> delete(k) end)
    :ok
  end

  @doc "Remove key from table and persistent drive"
  @spec delete(key) :: :ok | {:error, posix}
  def delete(key) do
    :ets.delete(@ets_table, key)
    remove_from_persistent_storage(key)
  end

  # Attempts to read file from persistent drive and return
  # value. If file does not exist default value will be
  # returned
  defp get_from_persistent_storage(key, default) do
    case File.read(key_to_file_path(key)) do
      {:ok, ""} ->
        default
      {:ok, contents} ->
        term = :erlang.binary_to_term(contents)
        :ets.insert @ets_table, [{key, term}]  # cache for future read
        term
      _ ->
        default
    end
  end

  # Removes file from persistent drive for key
  defp remove_from_persistent_storage(key) do
    case File.rm(key_to_file_path(key)) do
      {:error, :enoent} -> :ok
      other -> other
    end
  end

  # Converts key to file path using path stored in ets_table
  # stored in setup/1
  defp key_to_file_path(key) do
    [{@path_key, path}] = :ets.lookup(@ets_table, @path_key)
    Path.join(path, key_to_file_name(key))
  end

  defp key_to_file_name(key) do
    "#{key}.storage"
  end

end
