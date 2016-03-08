# FastFuzzy

FastFuzzy performs fast and fuzzy text pattern matching. It uses the Lucene analyzers to tokenize the text using a configurable analyzer chain and the extracted tokens
are matched against the searched text using ngram matching and a resulting match score is computed.

The original intent of this code was to perform on-the-fly matching of some specific categories of expressions or sentences in social media. Using an analyzer chain to tokenize, remove stop words, etc, allows performing the matching only on the relevant text tokens. Using ngram scoring provides the fuzzyness confidence score to find approximate matching text with typos or different spelling or any number of variations. With experimentation an "acceptable" score can be decided to establish if the searched text matches or not against what we are looking for.

Note that this gem also include a custom Lucene Twitter tokenizer, see usage examples below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_fuzzy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fast_fuzzy

## Usage

### Percolator

- First configure the `Percolator` with any number of text strings which represents what we are looking for, or the queries:

```ruby
p = FastFuzzy::Percolator.new

p << "looking for a restaurant"
p << "recommend a restaurant"
```

- Run the `Percolator` against some text. The result is the list of matching "queries" sorted in ascending score order.

```ruby
p.percolate("hey! anyone can recomment a good restaurant in montreal tonight?")
=> [[0, 0.5294117647058824], [1, 0.8421052631578947]]
```

In this example the last query  "recommend a restaurant" matched with a 0.842 or ~84% score.

```ruby
p.percolate("I am looking for a good suchi restaurant")
=> [[1, 0.47368421052631576], [0, 0.8823529411764706]]
```

In this example the first query  "looking for a restaurant" matched with a 0.882 or ~88% score.

### Custom Analyzer Chain

Included is a custom Twitter Tokenizer and can be used by defining an analyzer chain for the Percolator:

```ruby
p = FastFuzzy::Percolator.new(:analyzer_chain => [
  [Lucene::TwitterTokenizer],
  [Lucene::LowerCaseFilter],
  [Lucene::StopFilter, Lucene::StandardAnalyzer::STOP_WORDS_SET],
])

p << "looking for a restaurant"
p << "recommend a restaurant"
```

```ruby
p.percolate("RT yo lookin for a good restaurant #montreal #foodie")
=> [[1, 0.5263157894736842], [0, 0.7647058823529411]]
```

## Custom Twitter Tokenizer

The included custom Twitter Tokenizer was created to classify more Twitter specific tokens and help only match on actual text words. YMMV.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Building

- Install gradle-jflex-plugin

this uses the gradle-jflex-plugin. The original version does not support jflex 1.6.1 so
you can use my forked version at https://github.com/colinsurprenant/gradle-jflex-plugin
or the original if/when https://github.com/thomaslee/gradle-jflex-plugin/pull/2 is merged.

```sh
$ git clone https://github.com/colinsurprenant/gradle-jflex-plugin
#  or
$ git clone https://github.com/thomaslee/gradle-jflex-plugin
```

```sh
$ gradle build
$ gradle install
````

- Build Java sources

```sh
$ gradle build
```

### Tests / Specs

```sh
bundle install
```

```sh
bundle exec rspec
```

## Author

**Colin Surprenant** on [GitHub](https://github.com/colinsurprenant) and [Twitter](https://twitter.com/colinsurprenant).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/colinsurprenant/fast_fuzzy.

## License and Copyright

*FastFuzzy* is released under the Apache License, Version 2.0.
