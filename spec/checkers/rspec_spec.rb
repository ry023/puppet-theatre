require 'puppet_theatre/checkers/rspec'

describe PuppetTheatre::Checkers::Rspec do

  before(:context) do
    Dir.chdir('./test-fixtures') do
      Bundler.clean_system('bundle install --quiet --deployment')
    end
  end

  subject { described_class.new(config) }

  let(:runner) { double }

  describe '#call' do

    let(:config) do
      {bundler: `which bundle`.chomp, workdir: './test-fixtures'}
    end

    context 'When some specs fail' do

      it 'returns unsuccessful result' do
        result = subject.call(runner, 'www1.example.com')
        expect(result.summary).to match /Failed/
        expect(result.details).to match [%r{\A./spec/flawed_spec.rb:\d+ Something flawed fails\z}]
        expect(result).to be_alert
      end
    end

    context 'When all specs pass' do

      before do
        config[:args] = {'pattern' => 'spec/flawless_spec.rb'}
      end

      it 'returns successful result' do
        result = subject.call(runner, 'www1.example.com')
        expect(result.summary).to match /OK/
        expect(result.details).to be_empty
        expect(result).not_to be_alert
      end

    end

  end

end
