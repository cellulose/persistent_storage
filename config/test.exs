use Mix.Config

config :persistent_storage, tables: [
  test1: [ path: "/tmp/persistent_storage_test_1" ],
  test2: [ path: "/tmp/persistent_storage_test_2" ]
]
