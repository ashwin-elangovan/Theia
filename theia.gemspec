# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'theia/version'

Gem::Specification.new do |s|
  s.name = 'theia'
  s.version = Theia::VERSION
  s.authors = ['Ashwin Elangovan']
  s.email       = %w[ashelangovan97@gmail.com]
  s.homepage    = 'http://github.com/ashelangovan/theia'
  s.license     = 'MIT'
  s.date = '2019-09-13'
  s.summary = 'A Ruby gem to create, compress, compare PNGs or JPEGs using Google Puppeteer/Chromium'
  s.require_paths = ['lib']
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^spec/})

  s.add_dependency 'schmooze', '~> 0.2'

  s.add_development_dependency 'byebug', '~> 9.0.6'
  s.add_development_dependency 'mini_magick', '~> 4.9'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.72'
  s.add_development_dependency 'rubocop-rspec', '~> 1.33'
  s.add_development_dependency 'simplecov', '~> 0.17'
end
