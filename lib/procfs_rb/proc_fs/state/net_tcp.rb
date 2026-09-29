# frozen_string_literal: true

require 'json'
require_relative 'snapshot'
require_relative 'timestamped'
require_relative 'tcp_socket'

module ProcFS
  module State
    class NetTcp
      include Snapshot
      include Timestamped
      include Enumerable

      MEMBERS = %i[sockets timestamp source].freeze

      attr_reader(*MEMBERS)

      def initialize(sockets:, timestamp: Time.now, source: '/proc/net/tcp')
        @sockets   = sockets
        @timestamp = timestamp
        @source    = source
        freeze
      end

      def members
        MEMBERS
      end

      def to_h
        members.to_h { |m| [m, send(m)] }
      end

      def with(**changes)
        self.class.new(**to_h, **changes)
      end

      def ==(other)
        other.is_a?(self.class) && to_h == other.to_h
      end
      alias eql? ==

      def hash
        [self.class, to_h].hash
      end

      def to_s
        "TcpInfo(#{sockets.size} sockets @ #{timestamp.strftime('%H:%M:%S.%3N')})"
      end

      def inspect
        "#<ProcFS::State::TcpInfo source=#{source.inspect} " \
          "count=#{sockets.size} timestamp=#{timestamp.iso8601(3)}>"
      end

      def each(&)
        sockets.each(&)
      end

      def listening
        sockets.select(&:listening?)
      end

      def established
        sockets.select(&:established?)
      end

      def closed
        sockets.select(&:closed?)
      end

      def on_port(port)
        sockets.select { |s| s.local_port == port || s.remote_port == port }
      end

      def bound_on(address)
        addr = address.is_a?(IPAddr) ? address : IPAddr.new(address)
        sockets.select { |s| s.local_address == addr }
      end

      def by_state(state)
        sockets.select { |s| s.connection_state == state }
      end

      def empty?
        sockets.empty?
      end

      def size
        sockets.size
      end
    end
  end
end
