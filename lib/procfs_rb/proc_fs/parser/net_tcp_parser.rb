# frozen_string_literal: true

require_relative 'parser_interface'
require 'ipaddr'
require_relative '../state/net_tcp'
require_relative 'ipv4_hex_parser'

module ProcFS
  module Parser
    class NetTcpParser
      include ParserInterface

      TCP_SOURCE = '/proc/net/tcp'
      TCP6_SOURCE = '/proc/net/tcp6'

      def self.ipv4
        new(source: TCP_SOURCE, ip_parser: IPv4HexParser.new)
      end

      def self.ipv6
        new(source: TCP6_SOURCE, ip_parser: IPv6HexParser.new)
      end

      def initialize(source:, ip_parser:)
        @source = source
        @ip_parser = ip_parser
      end

      def parse(content, source: @source)
        read_at = Time.now
        lines = content.lines.drop(1) # Skip the header line

        sockets = lines.map { |line| parse_socket_line(line) }.compact

        State::NetTcp.new(
          sockets: sockets,
          timestamp: read_at,
          source: source
        )
      end

      private

      attr_reader :source, :ip_parser

      def parse_socket_line(line)
        parts = line.split

        # The header line has 8 parts, but a data line has 9
        return nil if parts.size < 9

        local_ip, local_port = parse_address(parts[1])
        remote_ip, remote_port = parse_address(parts[2])

        tx_hex, rx_hex = parts[4].split(':')

        State::TcpSocket.new(
          local_address: local_ip,
          local_port: local_port,
          remote_address: remote_ip,
          remote_port: remote_port,
          connection_state: State::TcpSocket::STATES.fetch(parts[3], :unknown),
          tx_queue: tx_hex.to_i(16),
          rx_queue: rx_hex.to_i(16),
          uid: parts[7].to_i,
          timeout: parts[8].to_i,
          inode: parts[9].to_i
        )
      end

      # Parses "0100007F:0050" (little-endian IPv4 hex + port hex)
      # into [IPAddr, Integer]
      def parse_address(hex_addr)
        ip_hex, port_hex = hex_addr.split(':')

        [ip_parser.parse(ip_hex), port_hex.to_i(16)]
      end
    end
  end
end
