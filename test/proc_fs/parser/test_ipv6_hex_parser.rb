# frozen_string_literal: true

require 'test_helper'
require 'ipaddr'
require_relative '../../../lib/procfs_rb/proc_fs/parser/ipv6_hex_parser'

class TestIPv6HexParser < Minitest::Test
  def setup
    @parser = ProcFS::Parser::IPv6HexParser.new
  end

  def test_parse_localhost
    # IPv6 loopback ::1
    # In /proc/net/tcp6, the first 32 bytes are in 4 groups of 32-bit little-endian
    # ::1 is 00000000 00000000 00000000 01000000
    hex = '00000000000000000000000001000000'

    assert_equal IPAddr.new('::1'), @parser.parse(hex)
  end

  def test_parse_zero
    # IPv6 unspecified ::
    hex = '00000000000000000000000000000000'

    assert_equal IPAddr.new('::'), @parser.parse(hex)
  end

  def test_return_type
    hex = '00000000000000000000000001000000'

    assert_instance_of IPAddr, @parser.parse(hex)
  end

  def test_parse_complex_address
    # Test a full IPv6 address
    ip_hex32 = '11223344556677889900AABBCCDDEEFF'

    assert_instance_of IPAddr, @parser.parse(ip_hex32)
  end

  def test_parse_malformed_hex
    # Test with characters that aren't hex
    hex = 'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'

    assert_instance_of IPAddr, @parser.parse(hex)
  end
end
