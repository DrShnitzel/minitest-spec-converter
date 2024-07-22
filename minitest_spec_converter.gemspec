# frozen_string_literal: true

require_relative "lib/minitest_spec_converter/version"

Gem::Specification.new do |spec|
  spec.name = "minitest-spec-converter"
  spec.version = MinitestSpecConverter::VERSION
  spec.authors = ["Aleksei Zaitsev"]
  spec.email = ["zaitsev.av.work@gmail.com"]

  spec.summary = "A gem to convert Minitest unit tests to spec style"
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = "https://github.com/DrShnitzel/minitest-spec-converter"
  spec.metadata["source_code_uri"] = "https://github.com/DrShnitzel/minitest-spec-converter"
  spec.metadata["changelog_uri"] = "https://github.com/DrShnitzel/minitest-spec-converter/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fileutils", "~> 1.0"
  spec.add_runtime_dependency "parser", "~> 3.3"
  spec.add_runtime_dependency "unparser", "~> 0.6"

  spec.add_development_dependency "byebug"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
