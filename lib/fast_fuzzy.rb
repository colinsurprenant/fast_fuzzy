# encoding: utf-8

require "java"

module FastFuzzy
  # local dev setup
  classes_dir = File.expand_path("../../build/classes/main", __FILE__)

  if File.directory?(classes_dir)
    # if in local dev setup, add target to classpath
    $CLASSPATH << classes_dir unless $CLASSPATH.include?(classes_dir)
  else
    jar_path = "fast_fuzzy/fastfuzzy-#{VERSION}.jar"
    begin
      require jar_path
    rescue Exception => e
      raise("Error loading #{jar_path}, cause: #{e.message}")
    end
  end
end

require "fast_fuzzy_jars"
require "fast_fuzzy/version"
require "fast_fuzzy/lucene"
require "fast_fuzzy/analyzer"
require "fast_fuzzy/ngram"
require "fast_fuzzy/percolator"
