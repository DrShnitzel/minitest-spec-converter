# MinitestSpecConverter

This gem helps to convert code in minitest or mixed style to minitest spec style.

Before conversion:

```ruby
class TestMeme < Minitest::Test
  def setup
    @meme = Meme.new
  end

  def test_that_kitty_can_eat
    assert_equal "OHAI!", @meme.i_can_has_cheezburger?
  end

  def test_that_it_will_not_blend
    refute_match /^no/i, @meme.will_it_blend?
  end
end
```

After conversion:

```ruby
describe Meme do
  before do
    @meme = Meme.new
  end

  describe "when asked about cheeseburgers" do
    it "must respond positively" do
      _(@meme.i_can_has_cheezburger?).must_equal("OHAI!")
    end
  end

  describe "when asked about blending possibilities" do
    it "won't say no" do
      _(@meme.will_it_blend?).wont_match(/^no/i)
    end
  end
end
```

## Installation

```bash
gem install minitest-spec-converter
```

## Usage

```bash
minitest-spec-converter --dir ./path/to/your/test/directory
```

It will format all the minitest test files in the directory to the minitest spec format. Directory argument is optional and defaults to the `./test`.

it is recommended to run `rubocop --fix` after running the converter to fix the formatting issues.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/minitest_spec_converter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/minitest_spec_converter/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MinitestSpecConverter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/minitest_spec_converter/blob/master/CODE_OF_CONDUCT.md).
