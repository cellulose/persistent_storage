# PersistentStorage

  Perisistently stores erlang terms to the filesystem

  A trivial way to write simple stuff that you might need "next time you run".
  
  Implemented as a singleton -- you can only have one instance, for simplicity.

  Performance is good because although each term is stored as a file, the reads
  come from a cache, so there is no need to cache locally.
  
## Usage Example
  
  Setup PersistentStorage, including the path in the filesystem where files
  will be stored. This must be called after each boot cycle before put/1, put/2
  or get/1, get/2 are called.

      PersistentStorage.setup path: "/path/to/storage/area"
      :ok

  Then, to store data you would:

      PersistentStorage.put :router_ip_address, {192,168,15,1}
      ...or...
      PersistentStorage.put router_ip_address: {192,168,15,1}
  
  Then, to retrieve the stored data:
      
      PersistentStorage.get :router_ip_address
      

## Contributing

We appreciate any contribution to Elixir, so check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide for more information. We usually keep a list of features and bugs [in the issue tracker][2].

## Building documentation

Building the documentation requires [ex_doc](https://github.com/elixir-lang/ex_doc) to be installed. Please refer to
their README for installation instructions and usage instructions.

## License

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.