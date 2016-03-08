require_relative '../spec_helper'

describe FastFuzzy::Ngram do

  it "should generate bigrams" do
    expect(FastFuzzy::Ngram.generate("allo")).to eq(["al", "ll", "lo"])
    expect(FastFuzzy::Ngram.generate("allo", 2)).to eq(["al", "ll", "lo"])
    expect(FastFuzzy::Ngram.generate([:a, :b, :c, :d], 2)).to eq([[:a, :b], [:b, :c], [:c, :d]])
  end

  it "should generate trigrams" do
    expect(FastFuzzy::Ngram.generate("allotoi", 3)).to eq(["all", "llo", "lot", "oto", "toi"])
    expect(FastFuzzy::Ngram.generate([:a, :b, :c, :d], 3)).to eq([[:a, :b, :c], [:b, :c, :d]])
  end

  it "should generate gram <= n" do
    expect(FastFuzzy::Ngram.generate("al", 2)).to eq(["al"])
    expect(FastFuzzy::Ngram.generate([:a, :b], 2)).to eq([[:a, :b]])
  end

  it "should generate gram < n" do
    expect(FastFuzzy::Ngram.generate("a", 2)).to eq(["a"])
    expect(FastFuzzy::Ngram.generate([:a], 2)).to eq([[:a]])
  end
end
