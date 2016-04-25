require 'puppet_theatre/reporters/html'

describe PuppetTheatre::Reporters::Html, with_tmpdir: true do

  subject { described_class.new(path: tmpdir, uri: 'https://example.net/path/') }

  let(:runner) { instance_double('PuppetTheatre::Runner') }

  it 'generates report in HTML' do
    results = {
      'www1.example.com' => {
        'Check' => double.tap do |stub|
          expect(stub).to receive(:alert?).at_least(:once).with(no_args).and_return(true)
          expect(stub).to receive(:summary).at_least(:once).with(no_args).and_return('Something failed')
          expect(stub).to receive(:details).at_least(:once).with(no_args).and_return(['Test1 failed', 'Test2 failed'])
        end
      },
      'www2.example.com' => {
        'Check' => double.tap do |stub|
          expect(stub).to receive(:alert?).at_least(:once).with(no_args).and_return(false)
          expect(stub).to receive(:summary).at_least(:once).with(no_args).and_return('OK')
          expect(stub).to receive(:details).at_least(:once).with(no_args).and_return([])
        end
      },
    }

    now = Time.new(2010, 2, 3, 4, 5, 6)

    expect(runner).to receive(:notify).with(a_string_matching(%r{https://example.net/path/20100203T040506.html}))

    Timecop.freeze(now) do
      subject.call(runner, results)
    end

    file = @tmpdir + '20100203T040506.html'
    expect(file).to exist

    content = File.read(file)
    expect(content).to include('Something failed').and include("Test1 failed\nTest2 failed")
  end

end
