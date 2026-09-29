# frozen_string_literal: true

require 'test_helper'

require 'json'

require_relative '../../../lib/procfs_rb/proc_fs/state/snapshot'

class TestSnapshot < Minitest::Test
  class MockSnapshot
    include ProcFS::State::Snapshot

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to_h
      { data: @data }
    end
  end

  def setup
    @snapshot = MockSnapshot.new('test data')
  end

  def test_snapshot_predicate
    assert_predicate @snapshot, :snapshot?
  end

  def test_to_json
    expected_json = { data: 'test data' }.to_json

    assert_equal expected_json, @snapshot.to_json
  end
end
