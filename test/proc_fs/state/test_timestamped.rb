# frozen_string_literal: true

require 'test_helper'

require_relative '../../../lib/procfs_rb/proc_fs/state/timestamped'

class TestTimestamped < Minitest::Test
  class MockTimestamped
    include ProcFS::State::Timestamped

    attr_reader :timestamp

    def initialize(timestamp)
      @timestamp = timestamp
    end
  end

  def test_age
    timestamp = Time.now - 10
    snapshot = MockTimestamped.new(timestamp)
    # Use delta for time comparisons to avoid flaky tests
    assert_in_delta 10, snapshot.age, 0.1
  end

  def test_recent
    timestamp = Time.now - 2
    snapshot = MockTimestamped.new(timestamp)

    assert snapshot.recent?(within_seconds: 5)
    refute snapshot.recent?(within_seconds: 1)
  end

  def test_stale
    timestamp = Time.now - 70
    snapshot = MockTimestamped.new(timestamp)

    assert snapshot.stale?(after_seconds: 60)
    refute snapshot.stale?(after_seconds: 100)
  end
end
