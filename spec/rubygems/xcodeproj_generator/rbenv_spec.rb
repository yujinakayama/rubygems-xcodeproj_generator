require 'rubygems/xcodeproj_generator/rbenv'
require 'fileutils'

module Rubygems::XcodeprojGenerator
  RSpec.describe Rbenv do
    include_context 'isolated environment'

    subject(:rbenv) { Rbenv.new }

    describe '.ruby_header_paths' do
      let(:rbenv_root) { nil }
      let(:cruby_versions) { [] }

      before do
        next unless rbenv_root

        cruby_versions.each do |version|
          dir = File.join(rbenv_root, "versions/#{version}/include/ruby-#{version}/x86_64-darwin14")
          FileUtils.makedirs(dir)
        end
      end

      context 'when environment variable RBENV_ROOT is set' do
        let(:rbenv_root) { File.expand_path('rbenv_root') }

        before do
          ENV['RBENV_ROOT'] = rbenv_root
        end

        context 'and any CRuby is installed' do
          let(:cruby_versions) { %w(2.1.0 2.2.0) }

          it 'returns base header path and platform header path for the latest Ruby version' do
            expect(rbenv.ruby_header_paths).to eq [
              File.join(rbenv_root, 'versions/2.2.0/include/ruby-2.2.0'),
              File.join(rbenv_root, 'versions/2.2.0/include/ruby-2.2.0/x86_64-darwin14')
            ]
          end
        end

        context 'and no CRuby is installed' do
          it 'returns empty array' do
            expect(rbenv.ruby_header_paths).to be_empty
          end
        end
      end

      context 'when environment variable RBENV_ROOT is not set' do
        before do
          ENV['RBENV_ROOT'] = nil
        end

        context 'and ~/.rbenv exists' do
          let(:rbenv_root) { File.expand_path('~/.rbenv') }

          context 'and any CRuby is installed' do
            let(:cruby_versions) { %w(2.1.0 2.2.0) }

            it 'returns base header path and platform header path for the latest Ruby version' do
              expect(rbenv.ruby_header_paths).to eq [
                File.join(rbenv_root, 'versions/2.2.0/include/ruby-2.2.0'),
                File.join(rbenv_root, 'versions/2.2.0/include/ruby-2.2.0/x86_64-darwin14')
              ]
            end
          end
        end

        context 'and ~/.rbenv does not exist' do
          it 'returns empty array' do
            expect(rbenv.ruby_header_paths).to be_empty
          end
        end
      end
    end
  end
end
