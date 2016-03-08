require_relative '../spec_helper'

describe FastFuzzy::Percolator do

  round4 = lambda {|x| x.round(4)}

  it "should add queries" do
    p = FastFuzzy::Percolator.new
    p << "test1"
    p << "test2"
    expect(p.queries).to eq(["test1", "test2"])

    p = FastFuzzy::Percolator.new(:queries => ["test1", "test2"])
    expect(p.queries).to eq(["test1", "test2"])
  end

  it "should percolate using standard chain by default" do
    p = FastFuzzy::Percolator.new
    p << "faire une chose"
    p << "etre subtil"

    expect(p.percolate("veux tu faire quelque chose?").map{|r| [r[0], r[1].round(4)]}).to eq([[0, 0.6429]])
    expect(p.percolate("allo toi").map{|r| [r[0], r[1].round(4)]}).to be_empty
    expect(p.percolate("il faut etre quelque peu subtil").map{|r| [r[0], r[1].round(4)]}).to eq([[1, 0.8]])

    p = FastFuzzy::Percolator.new
    p << "looking for a job"
    expect(p.percolate("I hate looking for a job").map{|r| [r[0], r[1].round(4)]}).to eq([[0, 1.0]])
  end

  it "should support configurable chain" do
    p = FastFuzzy::Percolator.new(:analyzer_chain => [[Lucene::StandardTokenizer], [Lucene::StandardFilter]])
    p << "foo bar"
    expect(p.percolate("FOO BAR")).to eq([])

    p = FastFuzzy::Percolator.new(:analyzer_chain => [[Lucene::StandardTokenizer], [Lucene::StandardFilter], [Lucene::LowerCaseFilter]])
    p << "foo bar"
    expect(p.percolate("FOO BAR")).to eq([[0, 1.0]])
  end

end