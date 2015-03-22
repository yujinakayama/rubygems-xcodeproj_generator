require 'rubygems/xcodeproj_generator/xcode'
require 'fileutils'

module Rubygems::XcodeprojGenerator
  RSpec.describe Xcode do
    include_context 'isolated environment'

    subject(:xcode) { Xcode.new(xcode_path) }
    let(:xcode_path) { File.expand_path('Applications/Xcode.app') }

    describe '.ruby_header_paths' do
      context 'when Xcode is installed' do
        before do
          FileUtils.makedirs(xcode_path)
        end

        context 'and any OS X SDK is installed' do
          # rubocop:disable LineLength
          before do
            next unless xcode_path

            [
              'Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/include/ruby-2.0.0/universal-darwin13',
              'Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/include/ruby-2.0.0/universal-darwin14',
            ].each do |dir|
              header_dir = File.join(xcode_path, dir)
              FileUtils.makedirs(header_dir)
            end
          end

          it 'returns base header path and platform header path for the latest OS X SDK version' do
            expect(xcode.ruby_header_paths).to eq [
              File.join(xcode_path, 'Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/include/ruby-2.0.0'),
              File.join(xcode_path, 'Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/include/ruby-2.0.0/universal-darwin14')
            ]
          end
          # rubocop:enable LineLength
        end

        context 'and no OS X SDK is installed' do
          it 'returns empty array' do
            expect(xcode.ruby_header_paths).to be_empty
          end
        end
      end

      context 'when Xcode is not installed' do
        it 'returns empty array' do
          expect(xcode.ruby_header_paths).to be_empty
        end
      end
    end
  end
end
