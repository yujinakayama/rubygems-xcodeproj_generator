RSpec.shared_context 'isolated environment' do
  original_env = ENV.to_hash

  around do |example|
    begin
      require 'tmpdir'

      Dir.mktmpdir do |tmpdir|
        tmpdir = File.realpath(tmpdir)

        virtual_home = File.join(tmpdir, 'home')
        Dir.mkdir(virtual_home)
        ENV['HOME'] = virtual_home

        Dir.chdir(tmpdir) do
          example.run
        end
      end
    ensure
      ENV.clear
      ENV.update(original_env)
    end
  end
end
