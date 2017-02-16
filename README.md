# PersistentStorage

[![Build Status](https://travis-ci.org/joelbyler/persistent_storage.svg?branch=master)](https://travis-ci.org/joelbyler/persistent_storage)

Stores and retrieves terms from small flat files on embedded systems.

`PersistentStorage` is intended for trivial persistent storage of basic system and application configuration information on embedded systems.   It is not intended to be a replacement for dets, sqlite, or many other far more capable databases.  It favors simplicity and robustness over performance and capability.

**IMPORTANT -- INCOMPATIBLE API CHANGE**

The API has has changed significantly for PersistentStorage 0.10.x -- you can find a summary of the changes in the [[CHANGELOG]].

If your project requires compatibility with the old (now deprecated) api, please make sure you specify "~> 0.9.0" in your project dependencies.

## Philosophy

PersistentStorage manages one more more persistent _tables_, each identified by an atom.  Each table maps to a user-configured directory in the filesystem.   The table keys and associated directories are configured in the application environment using `config.exs`.

Each table persists a set of _keys_ and associated values, where each key maps to a flat file in the table's directory that holds the serialized term.

The simple one-file-per-key/value model favors robustness over speed, reducing risk of write corruption on embedded devices that may power down unexpectedly.

Writes always write and close a file, so are very slow (but plenty fast enough for the kind of device configuration data that doesn't churn frequently).

Reads of a key from disk are slow the first time (they open and read a file), but the term is subsequently cached in ets, so further reads of the same key in a storage area are very fast, and no application-level cacheing is needed.

## Installation

1. Add `persistent_storage` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:persistent_storage, "~> 0.10.0"}]
  end
  ```

2. Ensure `persistent_storage` is started before your application:

  ```elixir
  def application do
    [applications: [:persistent_storage]]
  end
  ```

## Usage

Let's say your device wants a couple kinds of non-volatile storage.  

The first kind, which we'll call `settings`, will be used for storing user
settings. We're going to put it on the standard Nerves application data volume, `/root`.

We're going to assume that the /root partition might be rewritten anytime the user does something "resets to factory settings".

The second kind, which we'll call `provisioning`, is more persistent, and is perhaps on a volume usually mounted read-only (like /boot), that persists even when the application volume gets reformatted.

#### Configuration

Define one or more tables in your config.exs as follows...

```elixir
# my_app/config/config.exs
...
config :persistent_storage, tables: [
  settings: [path: "/root/storage/settings"],
  provisioning: [path: "/boot/provisioning"]
]
```

#### Writing

Writing to setttings, assuming the configuration in the previous section.  This will create the file at /root/storage/settings/network.

```elixir
iex> PersistentStorage.put :settings, :network, %{
  ip_address: {192,168,1,100}, mode: :static
}
```

#### Reading

Assuming we wrote as above, we can read it (this reads from ets cache if possible)...

```elixir
iex> PersistentStorage.get :settings, :network
%{ip_address: {192,168,1,100}, mode: :static}
```
Read some provisioning data -- for purposes of this example, we
assume it was written when device  was first flashed)

```elixir
iex> PersistentStorage.get :provisioning, :device_data
[serial_number: "302F1010", mfg_timestamp: "2016-05-04T03:28:35.279977Z"]
```
