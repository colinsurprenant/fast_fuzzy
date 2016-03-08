require 'fast_fuzzy/analyzer'
require 'fast_fuzzy/ngram'

module FastFuzzy

  class Percolator
    attr_reader :queries, :index
    N = 4 # >= 3 is necessary to wheight consecutiveness of words (ex "this car" => thi, his, is_, s_c, _ca, car)

    def initialize(options = {})
      @queries = options.delete(:queries) || []
      @analyzer_chain = options.delete(:analyzer_chain) || Analyzer::STANDARD_CHAIN

      @index = Hash.new{|h, k| h[k] = []}
      @query_terms_count = []

      build_index unless queries.empty?
    end

    def <<(query)
      @queries << query
      build_index
    end

    def percolate(str)
      analyser = Analyzer.new(str, @analyzer_chain)

      terms_phrase = analyser.select{|term| term[1] == Lucene::ALPHANUM_TYPE}.map{|term| term[0]}.join(' ')
      terms_phrase = " #{terms_phrase} "
      grams = Ngram.generate(terms_phrase, N).uniq
      score(lookup(grams))
    end

    private

    # build inverted index into @index that list all queries that belong to each term
    # {"term" => [query id, query id, ...]}
    def build_index
      @index.clear
      @query_terms_count.clear

      @queries.each_index do |query_id|
        analyser = Analyzer.new(@queries[query_id], @analyzer_chain)

        terms_phrase = analyser.select{|term| term[1] == Lucene::ALPHANUM_TYPE}.map{|term| term[0]}.join(' ')
        terms_phrase = " #{terms_phrase} "
        grams = Ngram.generate(terms_phrase, N).uniq
        @query_terms_count[query_id] = grams.size
        grams.each{|gram| @index[gram] << query_id}
      end
      @index.each_key{|k| @index[k] = @index[k].uniq}

      self
    end

    # for each search term lookup the index and keep count of the number of terms that matched each query
    # @param terms [Array<String>] search terms
    # @return [Hash] number of terms that matched each query, {query id => terms hit count}
    def lookup(terms)
      results = Hash.new(0)

      terms.each do |term|
        # @index[term] has list of query_id matching this term
        @index[term].each{|query_id| results[query_id] += 1}
      end

      results
    end


    # compute match score per query for given lookup result
    # @param result [Hash] number of terms that matched (> 0.0 score) each query, {query id => terms hit count}
    # @return [Array<Array>] sorted array by score of [[query id, score]]. will include only queries with score > 0, [] if no match
    def score(results)
      results.map{|k, v| [k, v.to_f / @query_terms_count[k]]}.sort_by{|r| r[1]}
    end

  end
end
