# encoding: utf-8

require "java"

module FastFuzy
  # local dev setup
  classes_dir = File.expand_path("../../build/classes/main", __FILE__)

  if File.directory?(classes_dir)
    # if in local dev setup, add target to classpath
    $CLASSPATH << classes_dir unless $CLASSPATH.include?(classes_dir)
  else
    raise("TODO: add jar loading")
  end
end

require "fast_fuzy_jars"
require "fast_fuzy/version"
require "fast_fuzy/lucene"
require "fast_fuzy/analyzer"
require "fast_fuzy/ngram"
require "fast_fuzy/percolator"
