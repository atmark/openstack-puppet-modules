require 'spec_helper'

describe 'swift::proxy::keystone' do

  let :facts do
    {}
  end

  let :fragment_file do
    '/var/lib/puppet/concat/_etc_swift_proxy-server.conf/fragments/79_swift_keystone'
  end

  let :pre_condition do
    '
      include concat::setup
      concat { "/etc/swift/proxy-server.conf": }
    '
  end

  it { should contain_file(fragment_file).with_content(/[filter:keystone]/) }

  it { should contain_file(fragment_file).with_content(/use = egg:swift#keystoneauth/) }

  describe 'with defaults' do

    it { should contain_file(fragment_file).with_content(/operator_roles = admin, SwiftOperator/) }
    it { should contain_file(fragment_file).with_content(/is_admin = true/) }
    it { should contain_file(fragment_file).with_content(/reseller_prefix = AUTH_/) }

  end

  describe 'with parameter overrides' do

    let :params do
      {
        :operator_roles  => 'foo',
        :is_admin        => 'false',
        :reseller_prefix => 'SWIFT_'
      }

      it { should contain_file(fragment_file).with_content(/operator_roles = foo/) }
      it { should contain_file(fragment_file).with_content(/is_admin = false/) }
      it { should contain_file(fragment_file).with_content(/reseller_prefix = SWIFT_/) }

    end

  end

end
