# frozen_string_literal: true

require_relative 'parser_interface'
require 'ipaddr'
require_relative '../state/net_tcp'

module ProcFS
  module Parser
    class NetTcpParser
      DEFAULT_SOURCE = '/proc/net/tcp'

      include ParserInterface

      def parse(content, source: DEFAULT_SOURCE)
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

      def parse_socket_line(line)
        parts = line.split
        return nil if parts.empty?

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

        # IPv4: 8 hex chars, stored in little-endian 32-bit
        ip_int = ip_hex.to_i(16)
        ip_bytes = [ip_int].pack('V').unpack('C4')
        ip_string = ip_bytes.join('.')

        [IPAddr.new(ip_string), port_hex.to_i(16)]
      end
    end
  end
end
