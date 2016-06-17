# SolrMakr

Create and destroy solr cores programmatically.

Assumes Solr 5.x with zookeeper running on the default ports.

See `solr-makr --help` to customize port information.

## Installation

    $ gem install solr_makr

## Usage

To set up:

```sh
# only need to run once, to set up local configuration directory

solr-makr setup
```

To create a core:

```sh
solr-makr create --name foo
```

To generate a valid yaml configuration for use with sunspot:

```sh
solr-makr yaml --name foo -o sunspot.yml
```

## Contributing

1. Fork it ( https://github.com/scryptmouse/solr_makr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
