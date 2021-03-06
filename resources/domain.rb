# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Resource:: domain
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2017 Xabier de Zuazo
# Copyright:: Copyright (c) 2013 Onddo Labs, SL.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default_action :create

property :domain, String, name_property: true
property :description, String, default: ''
property :aliases, Integer, default: 10
property :mailboxes, Integer, default: 10
property :active, [TrueClass, FalseClass], default: true
property :default_aliases, [TrueClass, FalseClass], default: false
property :login_username, String, required: true
property :login_password, String, required: true, sensitive: true
property :ssl, [TrueClass, FalseClass], default: lazy { default_ssl }
property :port, [Integer, String, NilClass], default: lazy { default_port }

include PostfixadminCookbook::ResourceHelpers

action :create do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  next if api.domain_exist?(domain)
  converge_by("Create #{new_resource}") do
    ruby_block "create domain #{domain}" do
      block do
        api.create_domain(
          domain: domain, description: description, aliases: aliases,
          mailboxes: mailboxes, active: active,
          default_aliases: default_aliases
        )
        Chef::Log.info("Created #{new_resource}")
      end
      action :create
    end
  end
end

action :delete do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  next unless api.domain_exist?(domain)
  converge_by("Delete #{new_resource}") do
    ruby_block "delete domain #{domain}" do
      block do
        api.delete_domain(domain)
        Chef::Log.info("Deleted #{new_resource}")
      end
      action :create
    end
  end
end
