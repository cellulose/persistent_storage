# PersistentStorage

[![Build Status](https://travis-ci.org/joelbyler/persistent_storage.svg?branch=master)](https://travis-ci.org/joelbyler/persistent_storage)

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

We appreciate any contribution to Cellulose Projects, so check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide for more information. We usually keep a list of features and bugs [in the issue tracker][2].

## Building documentation

Building the documentation requires [ex_doc](https://github.com/elixir-lang/ex_doc) to be installed. Please refer to
their README for installation instructions and usage instructions.

## License

The MIT License (MIT)

Copyright (c) 2015 Chris Dutton, Garth Hitchens

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
