require 'spec_helper'

describe PuppetTheatre::Hosts.find_class(:getent) do

  it 'includes Enumerable module' do
    expect(described_class).to include Enumerable
  end

  shared_context 'use stub getent' do
    around do |example|
      env = {
        'PATH' => ["#{Dir.pwd}/test-fixtures/bin", '/bin', '/usr/bin'].join(?:),
      }

      hosts.each_with_index do |host, i|
        env["TEST_HOSTS_#{i + 1}"] = host
      end

      orig_env = ENV.to_h
      begin
        ENV.update(env)
        example.run
      ensure
        ENV.replace(orig_env)
      end
    end
  end

  subject do
    described_class.new(pattern: pattern)
  end

  describe '#each' do
    include_context 'use stub getent' do
      let(:hosts) { ['www001.example.com', 'www002.example.com', 'api001.example.com'] }
    end

    context 'When a match-all pattern is given' do
      let(:pattern) { // }

      it 'yields all the available hosts' do
        expect {|b| subject.each(&b) }.to yield_successive_args(*hosts)
      end
    end

    context 'When a pattern is given' do
      let(:pattern) { /\Aapi\d+\./ }

      it 'yields only matching hosts' do
        expect {|b| subject.each(&b) }.to yield_successive_args('api001.example.com')
      end
    end

    context 'When a line contain multiple host names' do
      let(:pattern) { // }
      let(:hosts) { ['www001.example.com www.001.example.net'] }

      it 'yields each host' do
        expect {|b| subject.each(&b) }.to yield_successive_args(*hosts.first.split)
      end
    end
  end
end
