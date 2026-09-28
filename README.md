# ProcfsRb

A Ruby interface for browsing and analyzing the Linux `/proc` filesystem.

## Usage

Once loaded, it provides ProcFS module.

``` ruby
require 'procfs_rb'

procfs = ProcFS.new()

# get cpuinfo
cpuinfo = procfs.cpuinfo

# get all sockets
sockets = procfs.net.tcp.sockets
```

## Installation

Install the gem by executing:

```bash
gem install procfs_rb
```

Or add it to your Gemfile:

```ruby
gem 'procfs_rb'
```

## Usage

```ruby
require 'procfs_rb'

# Your usage examples here
```

## Development

Run `bin/setup` to install dependencies, `rake test` to run tests, and `bin/console` for an interactive prompt.

To install locally: `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitLab. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
