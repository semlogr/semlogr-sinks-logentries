require 'semlogr/sinks/logentries'

describe Semlogr::Sinks::Logentries do
  it 'has a version number' do
    expect(Semlogr::Sinks::Logentries::VERSION).not_to be nil
  end
end
