# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Resource:: mailbox
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2013 Onddo Labs, SL. (www.onddo.com)
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

actions :create

attribute :mailbox, kind_of: String, name_attribute: true
attribute :password, kind_of: String, required: true
attribute :name, kind_of: String, default: ''
attribute :active, kind_of: [TrueClass, FalseClass], default: true
attribute :mail, kind_of: [TrueClass, FalseClass], default: false
attribute :login_username, kind_of: String, required: true
attribute :login_password, kind_of: String, required: true
attribute :db_type, equal_to: %w(mysql postgresql)
attribute :db_user, kind_of: String
attribute :db_password, kind_of: String
attribute :db_name, kind_of: String
attribute :db_host, kind_of: String
attribute :db_port, kind_of: [Fixnum, String]
attribute :ssl, kind_of: [TrueClass, FalseClass]
attribute :port, kind_of: [Fixnum, String]

def initialize(*args)
  super
  @action = :create
end
