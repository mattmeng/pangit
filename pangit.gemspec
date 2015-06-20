# coding: utf-8
lib = File.expand_path( '../lib', __FILE__ )
$LOAD_PATH.unshift( lib ) unless $LOAD_PATH.include?( lib )

require 'pangit/constants'

Gem::Specification.new do |spec|
  spec.name          = "pangit"
  spec.version       = Pangit::VERSION
  spec.authors       = ["Matt Meng"]
  spec.email         = ["matt.meng@intel.com"]

  spec.summary       = %q{A pangit planning poker project.}
  spec.description   = %q{A pangit planning poker project.}
  spec.homepage      = "http://git.ida.lab/sit/pangit"
  spec.license       = "MIT"

  if spec.respond_to?( :metadata )
    spec.metadata['allowed_push_host'] = "http://whiteboard.ida.lab:9292"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir['./**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep( %r{^exe/} ) { |f| File.basename( f ) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra", "~> 1.4"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
end
