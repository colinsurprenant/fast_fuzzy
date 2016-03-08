module FastFuzzy

  class Analyzer
    include Enumerable

    STANDARD_CHAIN = [
      [Lucene::StandardTokenizer],
      [Lucene::StandardFilter],
      [Lucene::LowerCaseFilter],
      [Lucene::StopFilter, Lucene::StandardAnalyzer::STOP_WORDS_SET],
    ]

    def initialize(str, chain_definition = STANDARD_CHAIN)
      @str = str

      # first chain element must be the tokenizer, initialize it and set its reader
      definition = chain_definition.first
      clazz = definition.first
      params = definition[1..-1]
      tokenizer = clazz.new(*params)
      tokenizer.set_reader(java.io.StringReader.new(str))

      # initialize the following filters and build the stream chain
      stream = chain_definition[1..-1].inject(tokenizer) do |result, definition|
        clazz = definition.first
        params = definition[1..-1]
        clazz.new(result, *params)
      end

      # use CachingTokenFilter to allow multiple stream traversing
      @stream = Lucene::CachingTokenFilter.new(stream)
      @term_attr = @stream.addAttribute(Lucene::CharTermAttribute.java_class);
      @type_attr = @stream.addAttribute(Lucene::TypeAttribute.java_class);
    end

    # implement each for Enumerable
    def each(&block)
      @stream.reset
      while @stream.incrementToken
        yield [@term_attr.to_string, @type_attr.type]
      end
      @stream.end
    end

    def close
      @stream.close
    end
  end
end
