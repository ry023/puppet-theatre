describe PuppetTheatre::Runner do
  let(:stub_notifier) do
    class_double('PuppetTheatre::Notifiers::Stub').as_stubbed_const
  end

  describe '#notify' do
    subject do
      described_class.new do |c|
        c.add_notifier :stub, name: 'stub1'
        c.add_notifier :stub, name: 'stub2'
      end
    end

    it 'sends given message to all the notifiers' do
      expect(stub_notifier).to receive(:new).twice do
        double.tap do |stub|
          expect(stub).to receive(:call).with('TESTTEST')
          expect(stub).to receive(:call).with('TESTTESTTEST')
        end
      end

      subject.notify('TESTTEST')
      subject.notify('TESTTESTTEST')
    end
  end
end
