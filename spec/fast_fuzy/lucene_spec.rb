require_relative "../spec_helper"

describe Lucene do
  it 'has a version number' do
    expect(Lucene::VERSION).not_to be nil
  end

  it 'has the expected version' do
    expect(Lucene::VERSION).to eq("5.4.1")
  end
end
