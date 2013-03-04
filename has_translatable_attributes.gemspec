# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_translatable_attributes/version'

Gem::Specification.new do |gem|
  gem.name          = "has_translatable_attributes"
  gem.version       = HasTranslatableAttributes::VERSION
  gem.authors       = ["Philip Hallstrom"]
  gem.email         = ["philip@pjkh.com"]
  gem.description   = %q{Provides convenience methods for setting/getting I18n specific fields.}
  gem.summary       = %q{Provides convenience methods for setting/getting I18n specific fields.}
  gem.homepage      = "https://github.com/phallstrom/has_translatable_attributes"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
