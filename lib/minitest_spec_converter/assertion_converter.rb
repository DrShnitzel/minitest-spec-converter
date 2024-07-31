# frozen_string_literal: true

require_relative "assertion_rewriter"

class AssertionConverter
  def self.convert_assertions(content)
    buffer = Parser::Source::Buffer.new("(example)", source: content)
    parser = Unparser.parser
    ast = parser.parse(buffer)

    rewriter = AssertionRewriter.new
    rewriter.rewrite(buffer, ast)
  end
end
