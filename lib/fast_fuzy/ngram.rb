module FastFuzy

  class Ngram

    # generate the ngram for either the caracter grams of a string or the items grams of an array
    # example: generate("abcd") => ["ab", "bc", "cd"], generate([:a, :b, :c, :d]) => [[:a, :b], [:b, :c], [:c, :d]]
    # @param str_or_ary [String|Array] input string or array of anything
    # @return [Array] array or ngrams
    def self.generate(str_or_ary, n = 2)
      if (s = str_or_ary.size) <= n
        return [] if s.zero?
        return [str_or_ary]
      end

      (0..str_or_ary.size - n).map{|i| str_or_ary[i, n]}
    end
  end
end