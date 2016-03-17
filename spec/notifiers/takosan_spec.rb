require 'puppet_theatre/notifiers/takosan'

describe PuppetTheatre::Notifiers::Takosan do

  subject { described_class.new(config) }

  describe '#call' do
    let(:config) {
      {url: 'https://takosan.example.com:4649', channel: '#example', icon: ':simple_smile:', name: 'ikachan'}
    }

    it 'sends message to takosan' do
      takosan = class_double('Takosan').as_stubbed_const

      expect(takosan).to receive(:url=).with(config[:url])
      expect(takosan).to receive(:channel=).with(config[:channel])
      expect(takosan).to receive(:icon=).with(config[:icon])
      expect(takosan).to receive(:name=).with(config[:name])
      expect(takosan).to receive(:privmsg).with('TESTTEST')

      subject.call('TESTTEST')
    end
  end

end
