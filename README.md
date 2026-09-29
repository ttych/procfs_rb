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

## ProcFS

### Core

* It is Virtual: /proc does not exist on disk. It is an interface to kernel data structures.
* It is Generated on Read: Files do not "contain" static text. When a read() syscall occurs, the kernel executes a handler function that formats the current state into text on the fly.
* No Cross-File Atomicity: Because each file is generated independently, reading multiple files sequentially does not guarantee a consistent point-in-time view. State may change between read 1 and read 2.

### Node Abstractions


| Node Type           | Filesystem Representation | Semantic Role                    | Interface Contract                                                                                          |
|---------------------|---------------------------|----------------------------------|-------------------------------------------------------------------------------------------------------------|
| Directory           | dr-xr-xr-x                | Logical grouping / Namespace.    | Yields a list of child nodes.                                                                               |
| Observable File     | -r--r--r--                | Telemetry / State observation.   | Read-only. Returns a parsed, typed data structure.                                                          |
| Control File        | -rw-r--r--                | Tunable parameter / Mutation.    | Read/Write. Getter returns current value; Setter applies new value and may return success/error.            |
| Reference (Symlink) | lrwxrwxrwx                | Resolved relationship / Pointer. | Returns the target path (string) or resolves to the target object (e.g., resolving an FD to a socket/file). |


### Implementation rules

#### Rule 1: Explicit Snapshot Boundaries
Because /proc files are generated on the fly, an interface method like get_process_info(pid) should ideally read all required files for that specific request in a single pass, package them into a single immutable struct (a "Snapshot"), and return it.

Warning: Document clearly that even a single Snapshot is not strictly atomic across all kernel subsystems.

#### Rule 2: Handle Volatility Gracefully (Lifecycle)
Processes are born and die constantly.

A PID listed in a directory scan may cease to exist before its files are read.
The interface must treat ENOENT (No such file or directory) and ESRCH (No such process) not as fatal errors, but as expected lifecycle events (e.g., returning None, null, or throwing a specific ProcessVanishedException).

#### Rule 3: Encapsulate Raw Parsing
/proc files are notoriously difficult to parse reliably.

Example: /proc/<pid>/stat is space-separated, but the second field (comm) is wrapped in parentheses and can contain spaces or closing parentheses itself.

The interface must hide raw string parsing behind strongly-typed objects. Consumers should call process.get_memory_usage(), never parse_proc_pid_stat().

#### Rule 4: Separate Observation from Mutation
Do not mix read-only state getters with control setters in the same conceptual API surface without clear naming.

Example: process.get_oom_score() (Observation) vs process.set_oom_score_adj(500) (Mutation).

## Implementation



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
