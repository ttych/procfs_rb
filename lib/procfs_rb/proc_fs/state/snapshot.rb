# frozen_string_literal: true

module ProcFS
  module State
    module Snapshot
      def snapshot?
        true
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end
  end
end
