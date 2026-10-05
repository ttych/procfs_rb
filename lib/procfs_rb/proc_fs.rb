# frozen_string_literal: true

require_relative 'proc_fs/proc_fs_root'

module ProcFS
  def self.new(**)
    ProcFSRoot.new(**)
  end
end
