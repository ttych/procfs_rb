# frozen_string_literal: true

module ProcFS
  module Parser
    module ParserInterface
      def parse(content)
        raise NotImplementedError, 'Parser should implement #parse(content)'
      end
    end
  end
end
