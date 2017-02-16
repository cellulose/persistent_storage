defmodule PersistentStorageTest do
  use ExUnit.Case
  # doctest PersistentStorage

  @test1_path "/tmp/persistent_storage_test_1"
  @test2_path "/tmp/persistent_storage_test_2"

  test "test basic storage behavior" do
    File.rm_rf! @test1_path
    File.rm_rf! @test2_path
    assert nil == PersistentStorage.get :test1, :this
    assert File.exists?(@test1_path) == false
    assert :ok = PersistentStorage.put :test1, this: "that"
    assert nil == PersistentStorage.get :test1, :someotherkey
    assert :foo == PersistentStorage.get :test1, :someotherkey, :foo
    assert "that" == PersistentStorage.get :test1, :this
    assert File.exists?(@test1_path) == true
    assert File.exists?(@test2_path) == false
    PersistentStorage.put :test2, test: {:a, 2}
    assert File.exists?(@test2_path) == true
    assert {:a, 2} == PersistentStorage.get :test2, :test
    PersistentStorage.put :test1, _weird_: %{strange: [{:value}]}
    assert File.exists? Path.join(@test1_path, "/this.storage")
    assert File.exists? Path.join(@test1_path, "/_weird_.storage")
    assert File.exists? Path.join(@test2_path, "/test.storage")
    assert "that" == PersistentStorage.get :test1, :this
    assert %{strange: [{:value}]} == PersistentStorage.get :test1, :_weird_
    assert %{strange: [{:value}]} == PersistentStorage.get :test1, :_weird_, :bogus_default
    PersistentStorage.put :test1, _weird_: %{strange: [{:value}]}
    assert %{strange: [{:value}]} == PersistentStorage.get :test1, :_weird_
    PersistentStorage.put :test1, _weird_: [:science]
    assert [:science] == PersistentStorage.get :test1, :_weird_
  end

end
