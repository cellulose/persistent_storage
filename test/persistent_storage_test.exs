defmodule PersistentStorageTest do
  use ExUnit.Case

  test "Setup with default path" do
    cleanup_storage_and_setup
    assert File.exists? "/tmp"
  end

  test "Setup with optional path" do
    cleanup_storage_and_setup(storage_path)
    assert File.exists? storage_path
  end

  test "Store data" do
    cleanup_storage_and_setup(storage_path)
    assert File.exists? storage_path
    PersistentStorage.put this: "that", _weird_: %{strange: [{:value}]}
    assert File.exists? storage_path <> "/this.storage"
    assert File.exists? storage_path <> "/_weird_.storage"
    assert "that" == PersistentStorage.get :this
  end

  test "Get nil for undefined key" do
    cleanup_storage_and_setup(storage_path)
    assert nil == PersistentStorage.get :somekey
  end

  test "Get default value on get" do
    cleanup_storage_and_setup(storage_path)
    assert "something" == PersistentStorage.get :somekey, "something"
  end

  test "Store twice in same key" do
    cleanup_storage_and_setup(storage_path)
    PersistentStorage.put _weird_: %{strange: [{:value}]}
    assert %{strange: [{:value}]} == PersistentStorage.get :_weird_
    PersistentStorage.put _weird_: %{strange: [{:value}]}
  end

  test "persistent_storage seems to work" do
    cleanup_storage_and_setup(storage_path)
    PersistentStorage.put this: "that", _weird_: %{strange: [{:value}]}
    assert "that" == PersistentStorage.get :this
		assert "something" == PersistentStorage.get :somekey, "something"
    PersistentStorage.put :somekey, "something_else"
		assert "something_else" == PersistentStorage.get :somekey, "something"
    assert %{strange: [{:value}]} == PersistentStorage.get :_weird_
    PersistentStorage.put this: "that", _weird_: %{strange: [{:value}]}
  end

  defp cleanup_storage_and_setup(path \\ "/tmp") do
    File.rm_rf path
    PersistentStorage.setup path: path
  end

  defp storage_path, do: "/tmp/storage_wherever"
end
