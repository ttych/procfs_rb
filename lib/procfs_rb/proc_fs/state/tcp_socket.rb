# frozen_string_literal: true

require 'ipaddr'
require 'json'
require_relative 'snapshot'

module ProcFS
  module State
    class TcpSocket
      include Snapshot

      TCP = 'tcp'

      # TCP state constants (from linux/tcp_states.h)
      STATES = {
        '01' => :established,
        '02' => :syn_sent,
        '03' => :syn_recv,
        '04' => :fin_wait1,
        '05' => :fin_wait2,
        '06' => :time_wait,
        '07' => :close,
        '08' => :close_wait,
        '09' => :last_ack,
        '0A' => :listen,
        '0B' => :closing
      }.freeze

      MEMBERS = %i[
        protocol
        local_address local_port
        remote_address remote_port
        connection_state
        tx_queue rx_queue
        uid timeout inode
      ].freeze

      attr_reader(*MEMBERS)

      def initialize(local_address:, local_port:, remote_address:, remote_port:,
                     connection_state:, tx_queue:, rx_queue:, uid:, timeout:, inode:,
                     protocol: TCP)
        @protocol         = protocol
        @local_address    = local_address
        @local_port       = local_port
        @remote_address   = remote_address
        @remote_port      = remote_port
        @connection_state = connection_state
        @tx_queue         = tx_queue
        @rx_queue         = rx_queue
        @uid              = uid
        @timeout          = timeout
        @inode            = inode

        freeze
      end

      # --- Value semantics ---

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
        "#{local_address}:#{local_port} -> #{remote_address}:#{remote_port} [#{connection_state}]"
      end

      def inspect
        "#<ProcFS::State::TcpSocket #{self} tx=#{tx_queue} rx=#{rx_queue} uid=#{uid} inode=#{inode}>"
      end

      def listening?
        connection_state == :listen
      end

      def established?
        connection_state == :established
      end

      def closed?
        %i[close time_wait close_wait last_ack closing].include?(connection_state)
      end

      def ipv4?
        local_address.ipv4?
      end

      def ipv6?
        local_address.ipv6?
      end

      def local_endpoint
        "#{local_address}:#{local_port}"
      end

      def remote_endpoint
        "#{remote_address}:#{remote_port}"
      end
    end
  end
end
