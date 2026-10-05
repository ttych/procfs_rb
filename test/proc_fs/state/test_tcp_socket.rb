# frozen_string_literal: true

require 'test_helper'
require 'ipaddr'
require_relative '../../../lib/procfs_rb/proc_fs/state/tcp_socket'

class TestTcpSocket < Minitest::Test
  def setup
    @local_addr = IPAddr.new('127.0.0.1')
    @remote_addr = IPAddr.new('8.8.8.8')
    @socket = ProcFS::State::TcpSocket.new(
      local_address: @local_addr,
      local_port: 80,
      remote_address: @remote_addr,
      remote_port: 443,
      connection_state: :established,
      tx_queue: 0,
      rx_queue: 0,
      uid: 1000,
      timeout: 0,
      inode: 12_345
    )
  end

  def test_initialization
    assert_equal @local_addr, @socket.local_address
    assert_equal 80, @socket.local_port
    assert_equal :established, @socket.connection_state
    assert_predicate @socket, :frozen?
  end

  def test_predicates
    listen_socket = ProcFS::State::TcpSocket.new(**socket_attrs(connection_state: :listen))

    assert_predicate listen_socket, :listening?
    refute_predicate listen_socket, :established?

    test_socket = ProcFS::State::TcpSocket.new(**socket_attrs(connection_state: :established))

    assert_predicate test_socket, :established?
    refute_predicate test_socket, :listening?

    # Test all closed states
    %i[close time_wait close_wait last_ack closing].each do |state|
      closed_socket = ProcFS::State::TcpSocket.new(**socket_attrs(connection_state: state))

      assert_predicate closed_socket, :closed?, "State #{state} should be considered closed"
    end

    # Test a non-closed state
    listen_socket = ProcFS::State::TcpSocket.new(**socket_attrs(connection_state: :listen))

    refute_predicate listen_socket, :closed?
  end

  def test_ip_helpers
    assert_predicate @socket, :ipv4?
    refute_predicate @socket, :ipv6?

    ipv6_socket = ProcFS::State::TcpSocket.new(**socket_attrs(local_address: IPAddr.new('::1')))

    assert_predicate ipv6_socket, :ipv6?
    refute_predicate ipv6_socket, :ipv4?
  end

  def test_endpoints
    assert_equal '127.0.0.1:80', @socket.local_endpoint
    assert_equal '8.8.8.8:443', @socket.remote_endpoint
  end

  def test_value_object_behavior
    s2 = ProcFS::State::TcpSocket.new(**socket_attrs)

    assert_equal @socket, s2
    assert_equal @socket.hash, s2.hash

    modified = @socket.with(local_port: 8080)

    refute_equal @socket, modified
    assert_equal 8080, modified.local_port
  end

  private

  def socket_attrs(overrides = {})
    {
      local_address: @local_addr,
      local_port: 80,
      remote_address: @remote_addr,
      remote_port: 443,
      connection_state: :established,
      tx_queue: 0,
      rx_queue: 0,
      uid: 1000,
      timeout: 0,
      inode: 12_345
    }.merge(overrides)
  end
end
