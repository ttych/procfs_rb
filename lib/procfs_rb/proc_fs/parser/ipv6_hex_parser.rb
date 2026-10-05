# frozen_string_literal: true

require_relative 'parser_interface'

module ProcFS
  module Parser
    class IPv6HexParser
      include ParserInterface

      def parse(ip_hex)
        # Parses IPv6 address like "00000000000000000000000001000000:0050"
        # IPv6 addresses are 32 hex chars (128-bit) stored as 4 groups of 32-bit words in little-endian
        # Split into 4 groups of 8 hex chars (32-bit words)
        words = ip_hex.scan(/.{8}/)

        # Reverse each word (little-endian to big-endian conversion)
        bytes = words.map do |word|
          [word.to_i(16)].pack('N').bytes.reverse
        end.flatten

        # Convert to IPv6 string format
        ip_string = bytes.each_slice(2).map { |pair| pair.pack('C*').unpack1('H*') }.join(':')

        IPAddr.new(ip_string)
      end
    end
  end
end
