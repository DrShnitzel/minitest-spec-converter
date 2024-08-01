# frozen_string_literal: true

require "parser/current"
require "unparser"

class AssertionRewriter < Parser::TreeRewriter
  def on_send(node)
    case node.children[1]
    when :assert_equal
      new_node = convert_to_spec_method(node, :must_equal)
    when :assert_not_equal
      new_node = convert_to_spec_method(node, :wont_equal)
    when :assert_nil
      new_node = convert_to_spec_method(node, :must_be_nil)
    when :refute_nil
      new_node = convert_to_spec_method(node, :wont_be_nil)
    when :assert_empty
      new_node = convert_to_spec_method(node, :must_be_empty)
    when :refute_empty
      new_node = convert_to_spec_method(node, :wont_be_empty)
    when :assert_includes
      new_node = convert_to_spec_method(node, :must_include, reverse: true)
    when :refute_includes
      new_node = convert_to_spec_method(node, :wont_include, reverse: true)
    when :assert_match
      new_node = convert_to_spec_method(node, :must_match)
    when :refute_match
      new_node = convert_to_spec_method(node, :wont_match)
    when :assert_instance_of
      new_node = convert_to_spec_method(node, :must_be_instance_of)
    when :assert_kind_of
      new_node = convert_to_spec_method(node, :must_be_kind_of)
    when :refute_instance_of
      new_node = convert_to_spec_method(node, :wont_be_instance_of)
    when :refute_kind_of
      new_node = convert_to_spec_method(node, :wont_be_kind_of)
    when :assert
      new_node = convert_to_spec_method(node, :must_equal, value: Parser::AST::Node.new(:true), reverse: true)
    when :refute
      new_node = convert_to_spec_method(node, :must_equal, value: Parser::AST::Node.new(:false), reverse: true)
    when :assert_predicate
      new_node = convert_to_spec_predicate_method(node, :must_be)
    when :refute_predicate
      new_node = convert_to_spec_predicate_method(node, :wont_be)
    when :assert_operator
      new_node = convert_to_spec_operator_method(node, :must_be)
    when :refute_operator
      new_node = convert_to_spec_operator_method(node, :wont_be)
    when :assert_response
      new_node = convert_to_must_respond_with(
        node,
        :must_respond_with,
        value: Parser::AST::Node.new(:send, [nil, :response]),
        reverse: true
      )
    else
      return super
    end

    replace(node.location.expression, Unparser.unparse(new_node))
  end

  def on_block(node)
    method_name = node.children[0].children[1]
    return super unless %i[assert_raises refute_raises].include?(method_name)

    new_method_name = (method_name == :assert_raises) ? :must_raise : :wont_raise
    args = node.children[0].children[2..]
    body = node.children[2]

    code = <<~RUBY
      proc do
        #{Unparser.unparse(body)}
      end.#{new_method_name} #{Unparser.unparse(args.first)}
    RUBY

    new_node = Unparser.parse(code)

    replace(node.location.expression, Unparser.unparse(new_node))
  end

  private

  def convert_to_spec_method(node, new_method, reverse: false, value: nil)
    args = node.children[2..]
    args.reverse! if reverse
    obj = args.pop
    args = [value] if value

    Parser::AST::Node.new(:send, [
      Parser::AST::Node.new(:send, [nil, :_, obj]), new_method, *args
    ])
  end

  def convert_to_must_respond_with(node, new_method, reverse: false, value: nil)
    args = node.children[2..]
    args.reverse! if reverse
    args << value if value
    obj = args.pop

    Parser::AST::Node.new(:send, [
      Parser::AST::Node.new(:send, [nil, :_, obj]), new_method, *args
    ])
  end

  def convert_to_spec_predicate_method(node, new_method)
    obj, predicate = node.children[2], node.children[3]
    Parser::AST::Node.new(:send, [
      Parser::AST::Node.new(:send, [nil, :_, obj]), new_method, predicate
    ])
  end

  def convert_to_spec_operator_method(node, new_method)
    obj, operator, other = node.children[2], node.children[3], node.children[4]
    Parser::AST::Node.new(:send, [
      Parser::AST::Node.new(:send, [nil, :_, obj]), new_method, operator, other
    ])
  end
end
