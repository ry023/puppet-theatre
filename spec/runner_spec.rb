describe PuppetTheatre::Runner do

  let(:stub_hosts) do
    class_double('PuppetTheatre::Hosts::Stub').as_stubbed_const
  end

  let(:stub_checker) do
    class_double('PuppetTheatre::Checkers::Stub').as_stubbed_const
  end

  let(:stub_reporter) do
    class_double('PuppetTheatre::Reporters::Stub').as_stubbed_const
  end

  let(:stub_notifier) do
    class_double('PuppetTheatre::Notifiers::Stub').as_stubbed_const
  end

  describe '#run' do
    subject do
      described_class.new do |c|
        c.hosts_from :stub
        c.add_checker :stub, name: 'Stub1'
        c.add_checker :stub, name: 'Stub2'
        c.add_reporter :stub
      end
    end

    it 'runs' do
      expect(stub_hosts).to receive(:new) do
        double.tap do |stub|
          expect(stub).to receive(:each).and_yield('www1.example.com').and_yield('www2.example.com')
          stub.extend(Enumerable)
        end
      end

      expect(stub_checker).to receive(:new).twice do
        double.tap do |stub|
          expect(stub).to receive(:call).twice do |env, host|
            expect(env).to be subject
            {}
          end
        end
      end

      expect(stub_reporter).to receive(:new) do
        double.tap do |stub|
          expect(stub).to receive(:call) do |env, results|
            expect(env).to be subject
            expect(results).to match(
              'www1.example.com' => matching('Stub1' => be, 'Stub2' => be),
              'www2.example.com' => matching('Stub1' => be, 'Stub2' => be),
            )
          end
        end
      end

      subject.run
    end
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
