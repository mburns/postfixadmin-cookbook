# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL.
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
#

require_relative '../spec_helper'

describe 'postfixadmin::apache', order: :random do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postfixadmin']['ssl'] = true
    end.converge(described_recipe)
  end
  before { stub_command('/usr/sbin/apache2 -t').and_return(true) }

  it 'includes apache2::default recipe' do
    expect(chef_run).to include_recipe('apache2::default')
  end

  it 'includes php recipe' do
    expect(chef_run).to include_recipe('php')
  end

  it 'includes apache2::mod_php5 recipe' do
    expect(chef_run).to include_recipe('apache2::mod_php5')
  end

  it 'creates ssl_certificate' do
    expect(chef_run).to create_ssl_certificate('postfixadmin')
  end

  it 'ssl_certificate resource notifies apache' do
    resource = chef_run.ssl_certificate('postfixadmin')
    expect(resource).to notify('service[apache2]').to(:restart).delayed
  end

  context 'web_app postfixadmin definition' do
    it 'creates apache2 site' do
      expect(chef_run)
        .to create_template(%r{/sites-available/postfixadmin\.conf$})
    end
  end

  context 'ruby_block[web_app-postfixadmin-reload]' do
    let(:resource) do
      chef_run.find_resource(:ruby_block, 'web_app-postfixadmin-reload')
    end

    it 'notifies apache restart' do
      expect(resource).to notify('service[apache2]').to(:restart).immediately
    end

    it 'subscribes to a2ensite postfixadmin' do
      expect(resource).to subscribe_to('execute[a2ensite postfixadmin.conf]')
        .on(:create).immediately
    end
  end
end
