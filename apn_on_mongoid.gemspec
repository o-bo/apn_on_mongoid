# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apn_on_mongoid}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Eckermann", "all the APN on Rails contributors"]
  s.date = %q{2010-09-23}
  s.description = %q{Apple Push Notification delivery powered by Mongoid}
  s.email = %q{alex+apn_on_mongoid@alexeckermann.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    "LICENSE",
     "README.textile",
     "lib/apn_on_mongoid.rb",
     "lib/apn_on_mongoid/connection.rb",
     "lib/apn_on_mongoid/feedback.rb",
     "lib/apn_on_mongoid/models/device.rb",
     "lib/apn_on_mongoid/models/notification.rb",
     "lib/apn_on_mongoid/version.rb"
  ]
  s.homepage = %q{http://github.com/alex/apn_on_mongoid}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Apple Push Notification delivery powered by Mongoid}
  s.test_files = [
    "test/apn_on_mongoid_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["~> 2.0.0.beta.17"])
    else
      s.add_dependency(%q<mongoid>, ["~> 2.0.0.beta.17"])
    end
  else
    s.add_dependency(%q<mongoid>, ["~> 2.0.0.beta.17"])
  end
end

