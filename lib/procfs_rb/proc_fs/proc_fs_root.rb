# frozen_string_literal: true

DEFAULT_PROC_FS_ROOT = '/proc'

module ProcFS
  class ProcFSRoot
    attr_reader :root_path

    def initialize(root_path: DEFAULT_PROC_FS_ROOT)
      @root_path = File.expand_path(root_path)
    end
  end
end
