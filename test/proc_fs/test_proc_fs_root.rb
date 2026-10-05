# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/procfs_rb/proc_fs'
require_relative '../../lib/procfs_rb/proc_fs/proc_fs_root'

class TestProcFSRoot < Minitest::Test
  def test_initialize_default
    root = ProcFS::ProcFSRoot.new

    assert_equal '/proc', root.root_path
  end

  def test_initialize_custom
    custom_path = '/tmp/mock_proc'
    root = ProcFS::ProcFSRoot.new(root_path: custom_path)

    assert_equal File.expand_path(custom_path), root.root_path
  end

  def test_proc_fs_new
    root = ProcFS.new

    assert_instance_of ProcFS::ProcFSRoot, root
    assert_equal '/proc', root.root_path
  end

  def test_proc_fs_new_custom
    custom_path = '/tmp/mock_proc'
    root = ProcFS.new(root_path: custom_path)

    assert_instance_of ProcFS::ProcFSRoot, root
    assert_equal File.expand_path(custom_path), root.root_path
  end
end
