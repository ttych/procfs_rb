# frozen_string_literal: true

require 'test_helper'
require 'ipaddr'
require_relative '../../../lib/procfs_rb/proc_fs/parser/ipv4_hex_parser'

class TestIPv4HexParser < Minitest::Test
  def setup
    @parser = ProcFS::Parser::IPv4HexParser.new
  end

  def test_parse_localhost
    # 127.0.0.1 in little-endian hex is 0100007F
    assert_equal IPAddr.new('127.0.0.1'), @parser.parse('0100007F')
  end

  def test_parse_zero
    assert_equal IPAddr.new('0.0.0.0'), @parser.parse('00000000')
  end

  def test_parse_google_dns
    # 8.8.8.8 in little-endian hex is 08080808
    assert_equal IPAddr.new('8.8.8.8'), @parser.parse('08080808')
  end

  def test_return_type
    assert_instance_of IPAddr, @parser.parse('0100007F')
  end

  def test_parse_invalid_hex
    # Test with non-hex characters - to_i(16) will stop at first non-hex char
    # but we want to see if it produces an IPAddr (which it will, usually 0.0.0.0)
    # If the intention is to raise error, we should test that.
    # Given current implementation, it uses to_i(16).
    assert_instance_of IPAddr, @parser.parse('ZZZZZZZZ')
  end

  def test_parse_too_short
    # to_i(16) handles short strings, pack('V') will pad with zeros
    assert_instance_of IPAddr, @parser.parse('01')
  end
end
