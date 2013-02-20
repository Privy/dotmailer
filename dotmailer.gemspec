# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dotmailer/version"

Gem::Specification.new do |s|
  s.name        = "dotmailer"
  s.version     = Dotmailer::VERSION
  s.authors     = ["Econsultancy"]
  s.email       = ["tech@econsultancy.com"]
  s.homepage    = "https://github.com/econsultancy/dotmailer"
  s.summary     = %q{A Ruby wrapper around the dotMailer REST API: https://apiconnector.com/v2/help/wadl}
  s.summary     = %q{A Ruby wrapper around the dotMailer REST API: https://apiconnector.com/v2/help/wadl}

  s.rubyforge_project = "dotmailer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
