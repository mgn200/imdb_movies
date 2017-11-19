lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imdb_playfield/version'

Gem::Specification.new do |spec|
  spec.name           = 'imdb_playfield'
  spec.version        =  ImdbPlayfield::VERSION
  spec.authors        = ['Pavel Strakh']
  spec.email          = ['levelkaksi@gmail.com']
  spec.description    = %q{Study project with every main Ruby aspect covered.
  Play around with imdb movies parsing and filtering. Create online and offline theatres with tickets and schedule.
  Render html page with top 250 movies and their description.}
  spec.summary        = %q{Study Ruby with imdb movies help}
  spec.homepage       = ""
  spec.license        = "MIT"

  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'money'
  spec.add_dependency 'virtus'
  spec.add_dependency 'haml'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rspec-html-matchers'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'rake'
  spec
end
