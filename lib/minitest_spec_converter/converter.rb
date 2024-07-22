# frozen_string_literal: true

require_relative "assertion_converter"

module MinitestSpecConverter
  class Converter
    def initialize(file)
      @file = file
    end

    def convert
      content = File.read(@file)
      converted_content = convert_content(content)
      File.write(@file, converted_content)
      puts "Converted:  #{@file}"
    end

    private

    def convert_content(content)
      # Convert class definition to describe block
      content.gsub!(/class (\w+Test) < Minitest::Test/) do
        class_name = $1.gsub("Test", "")
        "describe #{class_name} do"
      end

      # Convert test method definitions to it blocks
      content.gsub!(/def test_(\w+)/) do
        method_name = $1.tr("_", " ")
        "it '#{method_name}' do"
      end

      # Convert setup to before block
      content.gsub!("def setup\n", "before do\n")
      content.gsub!("def teardown\n", "after do\n")

      # Convert assertions
      AssertionConverter.convert_assertions(content)
    end
  end
end
