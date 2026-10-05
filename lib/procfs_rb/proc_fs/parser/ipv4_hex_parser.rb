# frozen_string_literal: true

require_relative 'parser_interface'

module ProcFS
  module Parser
    class IPv4HexParser
      include ParserInterface

      def parse(ip_hex)
        # IPv4: 8 hex chars, stored in little-endian 32-bit
        ip_int = ip_hex.to_i(16)
        ip_bytes = [ip_int].pack('V').unpack('C4')
        ip_string = ip_bytes.join('.')

        IPAddr.new(ip_string)
      end
    end
  end
end
