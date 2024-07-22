require "minitest/autorun"
require "minitest/spec"
require_relative "../lib/minitest_spec_converter/converter"

describe MinitestSpecConverter::Converter do
  before do
    test_dir = "test/tmp"
    original_dir = "test/examples/original"
    FileUtils.mkdir_p(test_dir)
    FileUtils.cp_r(Dir.glob(File.join(original_dir, "*")), test_dir)
    @original_file = File.join(test_dir, "default_test.txt")
    @expected_content = File.read("test/examples/expected/default_test.txt")
  end

  it "converts test files to spec style" do
    converter = MinitestSpecConverter::Converter.new(@original_file)
    converter.convert
    converted_content = File.read(@original_file)
    assert_equal @expected_content, converted_content
  end
end
