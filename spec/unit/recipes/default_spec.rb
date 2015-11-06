#
# Cookbook Name:: couch_potato
# Spec:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 J. Morgan Lieberthal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

RSpec.describe 'couch_potato::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  %w(14.04 15.10).each do |version|
    context "on ubuntu v#{version}" do
      let(:opts) { { platform: 'ubuntu', version: version } }
      include_examples 'converges successfully'

      it 'clones the source' do
        expect(chef_run).to sync_git('/opt/CouchPotato').with(
          repository: 'https://github.com/RuudBurger/CouchPotatoServer.git'
        )
      end

      it 'installs lxml' do
        expect(chef_run).to install_apt_package('python-lxml')
      end

      it 'creates the systemd service' do
        expect(chef_run).to create_template(
          '/etc/systemd/system/couchpotato.service'
        )
      end

      it 'creates the group' do
        expect(chef_run).to create_group('couchpotato')
      end

      it 'creates the user' do
        expect(chef_run).to create_user('couchpotato').with(
          home: '/opt/CouchPotato',
          shell: '/bin/bash',
          group: 'couchpotato',
          system: true
        )
      end
    end
  end
end
