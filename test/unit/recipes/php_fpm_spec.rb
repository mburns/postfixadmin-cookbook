# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Onddo Labs, SL.
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

describe 'postfixadmin::php_fpm', order: :random do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before do
    stub_command(
      'test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d'
    ).and_return(true)
    stub_command('test -d /etc/php-fpm.d || mkdir -p /etc/php-fpm.d')
      .and_return(true)
  end

  it 'include php-fpm recipe' do
    expect(chef_run).to include_recipe('php-fpm')
  end

  it 'creates php FPM pool' do
    expect(chef_run).to create_template(
      "#{node['php-fpm']['pool_conf_dir']}/postfixadmin.conf"
    )
  end

  context 'on CentOS' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.6')
    end

    it 'fixes php session directory' do
      expect(chef_run).to create_directory('/var/lib/php/session')
        .with_owner('apache')
        .with_group('apache')
        .with_mode('00700')
    end
  end # on CentOS

  context 'on Fedora' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'fedora', version: '20')
    end

    it 'does not fix php session directory' do
      expect(chef_run).to_not create_directory('/var/lib/php/session')
    end
  end # on Fedora

  context 'on Ubuntu' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
    end

    it 'does not fix php session directory' do
      expect(chef_run).to_not create_directory('/var/lib/php/session')
    end
  end # on Ubuntu
end
