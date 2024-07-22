# frozen_string_literal: true

require "fileutils"
require_relative "version"
require_relative "converter"

module MinitestSpecConverter
  class MassConverter
    def initialize(test_dir)
      # check that dirrectory exists
      unless Dir.exist?(test_dir)
        puts "Directory must exist: #{test_dir}"
        exit
      end
      @test_dir = test_dir
    end

    def convert
      setup
      get_all_files.each do |file|
        puts "Converting: #{file}"
        Converter.new(file).convert
      end
      cleanup
    end

    private

    def setup
      raise "directory must exits #{@test_dir}\e" unless Dir.exist?(@test_dir)
      @start_time = Time.now
      puts "Starting conversion at #{@start_time}"
    end

    def get_all_files
      Dir.glob("#{@test_dir}/**/*_test.rb")
    end

    def cleanup
      puts "Successfully converted all files in #{Time.now - @start_time} seconds"
    end
  end
end
