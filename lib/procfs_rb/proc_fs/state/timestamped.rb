# frozen_string_literal: true

module ProcFS
  module State
    module Timestamped
      def age
        Time.now - timestamp
      end

      def recent?(within_seconds: 5)
        age < within_seconds
      end

      def stale?(after_seconds: 60)
        age > after_seconds
      end
    end
  end
end
