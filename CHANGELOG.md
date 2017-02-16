# CHANGELOG

## v0.10.1 (16-Feb-2017)

- removed inappropriate debugging IO.puts that was left in code
- added a dedicated process to own the ets tables
- added warnings

## v0.10.0 (15-Feb-2017)

__IMPORTANT!!__  -- The API has changed a fair in an incompatible way since v0.9.x. It also has a new home (for now) at ghitchens/persistent_storage

Reference cellulose/persistent_storage and specify version ~>0.9.0 in your deps if you have code compiled against the old API.

* Backwards incompatible changes
  - now configured in `config.exs` not in `setup()`
  - APIs now take a storage as first parameter
  - setting of multiple keys in a single put is no longer supported (this was not used heavily and complicated the API)
  - put(), delete() return better responses, but might break previous matches

* Other changes
  - now using Apache-2.0 LICENSE

## v0.9.0 (2016)

- Broken out from http://github.com:/ghitchens/echo
