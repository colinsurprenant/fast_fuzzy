require_relative '../spec_helper'

describe FastFuzy::Analyzer do

  it "should support to_a" do
    analyzer = FastFuzy::Analyzer.new("aa bb")
    expect(analyzer.to_a).to be_a(Array)
    expect(analyzer.to_a.size).to eq(2)
  end

  it "should support each" do
    analyzer = FastFuzy::Analyzer.new("aa bb")
    result = []
    analyzer.each{|token| result << token}
    expect(result.size).to eq(2)
  end

  shared_examples :analyzer do
    it "should analyse and extract correct type" do
      tests.each do |test|
        analyzer = FastFuzy::Analyzer.new(test.first, chain)
        expect(analyzer.to_a).to eq(test.last)
      end
    end

    it "should support each" do
      analyzer = FastFuzy::Analyzer.new("aa bb cc", chain)
      results = []
      analyzer.each{|term| results << term}
      expect(results).to eq([["aa", "<ALPHANUM>"], ["bb", "<ALPHANUM>"], ["cc", "<ALPHANUM>"]])
    end

    it "should support Enumerable" do
      analyzer = FastFuzy::Analyzer.new("aa bb 12", chain)
      expect(analyzer.map{|term| term.first}).to eq(["aa", "bb", "12"])
      expect(analyzer.map{|term| term.last}).to eq(["<ALPHANUM>", "<ALPHANUM>", "<NUM>"])
    end
  end

  context "using default analyzer chain" do
    it_behaves_like :analyzer do
      let(:tests) {[
        # the following tests are actually copied from the TwitterTokenizer tests below and
        # ajusted to the StandardTokenizer chain results.
        # TODO: make better tests for StandardTokenizer & default chain

        ["2012 $80K/year", [["2012", "<NUM>"],  ["80k", "<ALPHANUM>"], ["year", "<ALPHANUM>"]]],
        ["is @ 7.9% and 1% not 4th", [["7.9", "<NUM>"], ["1", "<NUM>"], ["4th", "<ALPHANUM>"]]],

        ["it's o'reilly o'reilly's hey", [["it's", "<ALPHANUM>"], ["o'reilly", "<ALPHANUM>"], ["o'reilly's", "<ALPHANUM>"], ["hey", "<ALPHANUM>"]]],

        ["at&t excite@home", [["t", "<ALPHANUM>"], ["excite", "<ALPHANUM>"], ["home", "<ALPHANUM>"]]],

        ["I.B.M. is big", [["i.b.m", "<ALPHANUM>"], ["big", "<ALPHANUM>"]]],

        ["see @colinsurprenant do #win yeah", [["see", "<ALPHANUM>"], ["colinsurprenant", "<ALPHANUM>"], ["do", "<ALPHANUM>"], ["win", "<ALPHANUM>"], ["yeah", "<ALPHANUM>"]]],

        ["go http://colinsurprenant.com/ http://a go", [["go", "<ALPHANUM>"], ["http", "<ALPHANUM>"], ["colinsurprenant.com", "<ALPHANUM>"], ["http", "<ALPHANUM>"], ["go", "<ALPHANUM>"]]],

        ["colin.surprenant@gmail.com", [["colin.surprenant", "<ALPHANUM>"], ["gmail.com", "<ALPHANUM>"]]],

        ["Face-Lift - Graphic", [["face", "<ALPHANUM>"], ["lift", "<ALPHANUM>"], ["graphic", "<ALPHANUM>"]]],

        ["DUDZ :) :P :( 8-(", [["dudz", "<ALPHANUM>"], ["p", "<ALPHANUM>"], ["8", "<NUM>"]]],

        ["RT stoopid #FF ", [["rt", "<ALPHANUM>"], ["stoopid", "<ALPHANUM>"], ["ff", "<ALPHANUM>"]]],
      ]}

      let(:chain) { FastFuzy::Analyzer::STANDARD_CHAIN }
    end
  end

  context "using TwitterTokenizer chain" do
    it_behaves_like :analyzer do
      let(:tests) {[
        # NUM
        ["2012 $80K/year", [["2012", "<NUM>"],  ["$80k", "<NUM>"], ["year", "<ALPHANUM>"]]],
        ["is @ 7.9% and 1% not 4th", [["7.9%", "<NUM>"], ["1%", "<NUM>"], ["4th", "<ALPHANUM>"]]],

        # APOSTROPHE
        ["it's o'reilly o'reilly's hey", [["it's", "<APOSTROPHE>"], ["o'reilly", "<APOSTROPHE>"], ["o'reilly's", "<APOSTROPHE>"], ["hey", "<ALPHANUM>"]]],

        # COMPANY
        ["at&t excite@home", [["at&t", "<COMPANY>"], ["excite@home", "<COMPANY>"]]],

        # ACRONYM
        ["I.B.M. is big", [["i.b.m.", "<ACRONYM>"], ["big", "<ALPHANUM>"]]],

        # USERNAME & HASHTAG
        ["see @colinsurprenant do #win yeah", [["see", "<ALPHANUM>"], ["@colinsurprenant", "<USERNAME>"], ["do", "<ALPHANUM>"], ["#win", "<HASHTAG>"], ["yeah", "<ALPHANUM>"]]],

        # URL
        ["go http://colinsurprenant.com/ http://a go", [["go", "<ALPHANUM>"], ["http://colinsurprenant.com/", "<URL>"], ["http://a", "<URL>"], ["go", "<ALPHANUM>"]]],

        # EMAIL
        ["colin.surprenant@gmail.com", [["colin.surprenant@gmail.com", "<EMAIL>"]]],

        # DASH
        ["Face-Lift - Graphic", [["face-lift", "<DASH>"], ["graphic", "<ALPHANUM>"]]],

        # EMOTICON
        ["DUDZ :) :P :( 8-(", [["dudz", "<ALPHANUM>"], [":)", "<EMOTICON>"], [":p", "<EMOTICON>"], [":(", "<EMOTICON>"], ["8-(", "<EMOTICON>"]]],

        # HASHTAG & RT
        ["RT stoopid #FF ", [["rt", "<RT>"], ["stoopid", "<ALPHANUM>"], ["#ff", "<HASHTAG>"]]],
      ]}

      let(:chain) {[
        [Lucene::TwitterTokenizer],
        [Lucene::LowerCaseFilter],
        [Lucene::StopFilter, Lucene::StandardAnalyzer::STOP_WORDS_SET],
      ]}
    end
  end

end
