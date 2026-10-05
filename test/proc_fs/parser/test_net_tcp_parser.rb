# frozen_string_literal: true

require 'test_helper'
require 'ipaddr'
require_relative '../../../lib/procfs_rb/proc_fs/parser/net_tcp_parser'

class TestNetTcpParser < Minitest::Test
  def setup
    @parser = ProcFS::Parser::NetTcpParser.ipv4
    @sample_content = <<~CONTENT
      sl  local_address rem_address   st tx_queue rx_queue tr tm->filling
      0: 0100007F:0050 00000000:0000 0A 0:0 0:0 0 0 10
      1: 0100007F:04D2 08080808:01BB 01 0:0 0:0 100 12345 12345
    CONTENT
  end

  def test_parse_basic
    result = @parser.parse(@sample_content)

    assert_instance_of ProcFS::State::NetTcp, result
    assert_equal 2, result.size
    assert_equal '/proc/net/tcp', result.source
    assert_kind_of Time, result.timestamp
  end

  def test_parse_socket_details
    result = @parser.parse(@sample_content)

    # Socket 0: 127.0.0.1:80, state :listen (0A)
    s0 = result.sockets.find { |s| s.local_port == 80 }

    assert_equal IPAddr.new('127.0.0.1'), s0.local_address
    assert_equal :listen, s0.connection_state
    assert_equal 0, s0.tx_queue
    assert_equal 0, s0.rx_queue
    assert_equal 10, s0.timeout

    # Socket 1: 127.0.0.1:1234, 8.8.8.8:443, state :established (01)
    s1 = result.sockets.find { |s| s.local_port == 1234 }

    assert_equal IPAddr.new('127.0.0.1'), s1.local_address
    assert_equal IPAddr.new('8.8.8.8'), s1.remote_address
    assert_equal 443, s1.remote_port
    assert_equal :established, s1.connection_state
    assert_equal 12_345, s1.timeout
  end

  def test_parse_empty_content
    result = @parser.parse("sl  local_address rem_address   st tx_queue rx_queue tr tm->filling\n")

    assert_empty result.sockets
  end

  def test_parse_with_custom_source
    result = @parser.parse(@sample_content, source: '/custom/path')

    assert_equal '/custom/path', result.source
  end

  def test_parse_unknown_state
    content = <<~CONTENT
      sl  local_address rem_address   st tx_queue rx_queue tr tm->filling
      0: 0100007F:0050 00000000:0000 ZZ 0:0 0:0 0 0 10
    CONTENT
    result = @parser.parse(content)

    assert_equal :unknown, result.sockets.first.connection_state
  end

  def test_parse_malformed_line
    content = <<~CONTENT
      sl  local_address rem_address   st tx_queue rx_queue tr tm->filling
      0: 0100007F:0050 missing_columns
    CONTENT
    # It should handle it gracefully by returning nil for the socket line
    result = @parser.parse(content)

    assert_empty result.sockets
  end

  def test_parse_ipv6_source
    ipv6_parser = ProcFS::Parser::NetTcpParser.ipv6
    content = <<~CONTENT
      sl  local_address rem_address   st tx_queue rx_queue tr tm->filling
      0: 00000000000000000000000001000000:0050 00000000000000000000000000000000:0000 0A 0:0 0:0 0 0 10
    CONTENT
    result = ipv6_parser.parse(content)

    assert_equal IPAddr.new('::1'), result.sockets.first.local_address
    assert_equal '/proc/net/tcp6', result.source
  end
end
