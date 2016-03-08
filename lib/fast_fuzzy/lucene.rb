require 'java'

module Lucene
  Version = org.apache.lucene.util.Version
  VERSION = Version::LATEST.to_string

  ALPHANUM_TYPE = "<ALPHANUM>".freeze

  module Analysis
    include_package "org.apache.lucene.analysis"

    module Standard
      include_package "org.apache.lucene.analysis.standard"
    end

    module TokenAttributes
      include_package 'org.apache.lucene.analysis.tokenattributes'
    end

    module Core
      include_package 'org.apache.lucene.analysis.core'
    end
  end

  module FastFuzzy
    # custom TwitterTokenizer
    include_package "com.colinsurprenant.fastfuzzy"
  end

  StandardTokenizer = Analysis::Standard::StandardTokenizer
  ClassicTokenizer = Analysis::Standard::ClassicTokenizer
  StandardAnalyzer = Analysis::Standard::StandardAnalyzer
  StandardFilter = Analysis::Standard::StandardFilter
  LowerCaseFilter = Analysis::Core::LowerCaseFilter
  StopFilter = Analysis::Core::StopFilter
  CharTermAttribute = Analysis::TokenAttributes::CharTermAttribute
  CachingTokenFilter = Analysis::CachingTokenFilter
  TypeAttribute = Analysis::TokenAttributes::TypeAttribute
  FlagsAttribute = Analysis::TokenAttributes::FlagsAttribute

  TwitterTokenizer = FastFuzzy::TwitterTokenizer
end
