# frozen_string_literal: true

require_relative 'lib/procfs_rb/version'

Gem::Specification.new do |spec|
  spec.name = 'procfs_rb'
  spec.version = ProcfsRb::VERSION
  spec.authors = ['Thomas Tych']
  spec.email = ['thomas.tych@gmail.com']

  spec.summary = 'ProcFS interface.'
  spec.homepage = 'https://gitlab.com/ttych/procfs_rb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  # spec.metadata["allowed_push_host"] = ""
  spec.metadata['rubygems_mfa_required'] = 'true'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .gitlab-ci.yml .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bump', '~> 0.10.0'
  spec.add_development_dependency 'bundler', '~> 4.0.21'
  spec.add_development_dependency 'byebug', '~> 13.0'
  spec.add_development_dependency 'irb', '~> 1.18'
  spec.add_development_dependency 'minitest', '~> 6.0', '>= 6.0.6'
  spec.add_development_dependency 'rake', '~> 13.4', '>= 13.4.2'
  spec.add_development_dependency 'reek', '~> 6.5'
  spec.add_development_dependency 'rubocop', '~> 1.91'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.40.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.7.1'
  spec.add_development_dependency 'simplecov', '~> 1.3', '>= 1.3.0'
end
