# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# More info at http://berkshelf.com/#the-berksfile

source 'https://supermarket.chef.io'
my_cookbook = 'postfixadmin'

# Berkshelf helper to include a local cookbook from disk.
#
# @param name [String] cookbook name.
# @param version [String] cookbook version requirement.
# @param options [Hash] #cookbook method options.
# return void
def local_cookbook(name, version = '>= 0.0.0', options = {})
  cookbook(name, version, {
    path: "../../cookbooks/#{name}"
  }.merge(options))
end

# "This resource is written with Chef 12.5 custom resources" error:
if ENV.key?('CHEF_VERSION') &&
   Gem::Requirement.new(ENV['CHEF_VERSION'])
                   .satisfied_by?(Gem::Version.new('11.0.0'))
  cookbook 'rsyslog', '~> 2.0'
end

cookbook 'apt'
cookbook 'netstat'
cookbook 'selinux'
metadata

# Minitest Chef Handler
# More info at https://github.com/calavera/minitest-chef-handler
if ::File.directory?(::File.join('files', 'default', 'tests', 'minitest')) ||
   ::File.directory?(
     ::File.join(
       'test', 'cookbooks', "#{my_cookbook}_test", 'files', 'default', 'tests',
       'minitest'
     )
   )
  cookbook 'minitest-handler'
end

# Integration tests cookbook:
if ::File.directory?("./test/cookbooks/#{my_cookbook}_test")
  cookbook "#{my_cookbook}_test", path: "./test/cookbooks/#{my_cookbook}_test"
end
