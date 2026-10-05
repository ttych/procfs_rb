# frozen_string_literal: true

require 'test_helper'
require 'ipaddr'
require_relative '../../../lib/procfs_rb/proc_fs/state/net_tcp'
require_relative '../../../lib/procfs_rb/proc_fs/state/tcp_socket'

class TestNetTcp < Minitest::Test
  def setup
    @sockets = [
      ProcFS::State::TcpSocket.new(
        local_address: IPAddr.new('127.0.0.1'), local_port: 80,
        remote_address: IPAddr.new('0.0.0.0'), remote_port: 0,
        connection_state: :listen, tx_queue: 0, rx_queue: 0, uid: 0, timeout: 0, inode: 1
      ),
      ProcFS::State::TcpSocket.new(
        local_address: IPAddr.new('127.0.0.1'), local_port: 1234,
        remote_address: IPAddr.new('8.8.8.8'), remote_port: 443,
        connection_state: :established, tx_queue: 0, rx_queue: 0, uid: 1000, timeout: 0, inode: 2
      ),
      ProcFS::State::TcpSocket.new(
        local_address: IPAddr.new('127.0.0.1'), local_port: 5678,
        remote_address: IPAddr.new('1.1.1.1'), remote_port: 80,
        connection_state: :time_wait, tx_queue: 0, rx_queue: 0, uid: 1000, timeout: 0, inode: 3
      )
    ]
    @tcp_info = ProcFS::State::NetTcp.new(sockets: @sockets)
  end

  def test_initialization
    assert_equal @sockets, @tcp_info.sockets
    assert_kind_of Time, @tcp_info.timestamp
    assert_equal '/proc/net/tcp', @tcp_info.source
    assert_predicate @tcp_info, :frozen?
  end

  def test_enumerable
    assert_equal 3, @tcp_info.size
    assert_equal @sockets, @tcp_info.to_a
  end

  def test_query_helpers
    assert_equal 1, @tcp_info.listening.size
    assert_equal 80, @tcp_info.listening.first.local_port

    assert_equal 1, @tcp_info.established.size
    assert_equal 1234, @tcp_info.established.first.local_port

    assert_equal 1, @tcp_info.closed.size
    assert_equal 5678, @tcp_info.closed.first.local_port
  end

  def test_on_port
    assert_equal 2, @tcp_info.on_port(80).size
    assert_equal 1, @tcp_info.on_port(443).size # remote port
    assert_empty @tcp_info.on_port(9999)
  end

  def test_bound_on
    assert_equal 3, @tcp_info.bound_on('127.0.0.1').size
    assert_empty @tcp_info.bound_on('192.168.1.1')
  end

  def test_by_state
    assert_equal 1, @tcp_info.by_state(:listen).size
    assert_equal 1, @tcp_info.by_state(:established).size
    assert_empty @tcp_info.by_state(:syn_sent)
  end

  def test_empty_state
    empty_tcp = ProcFS::State::NetTcp.new(sockets: [])

    assert_predicate empty_tcp, :empty?
    assert_equal 0, empty_tcp.size
  end
end
