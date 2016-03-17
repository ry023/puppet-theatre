require 'puppet_theatre/notifiers/console'

describe PuppetTheatre::Notifiers::Console do

  subject { described_class.new({}) }

  describe '#call' do
    it 'outputs given argument to stdout' do
      expect { subject.call('TESTTEST') }.to output("TESTTEST\n").to_stdout
    end
  end

end
