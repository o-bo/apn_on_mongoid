# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "apn_on_mongoid"
  s.version = "0.0.25"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Olivier", "Alex Eckermann", "all the APN on Rails contributors"]
  s.date = "2012-01-09"
  s.description = "Apple Push Notification delivery powered by Mongoid"
  s.email = "olivier@kasual.biz"
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
    "lib/apn_on_mongoid/models/device_owner.rb",
    "lib/apn_on_mongoid/models/notification.rb",
    "lib/apn_on_mongoid/version.rb"
  ]
  s.homepage = "http://github.com/o-bo/apn_on_mongoid"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Apple Push Notification delivery powered by Mongoid"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, [">= 2.0.0"])
    else
      s.add_dependency(%q<mongoid>, [">= 2.0.0"])
    end
  else
    s.add_dependency(%q<mongoid>, [">= 2.0.0"])
  end
end

