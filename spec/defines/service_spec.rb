require 'spec_helper'

describe 'systemd::service' do
  let :pre_condition do
    'include systemd'
  end
  let(:title) {'my'}
  context 'on osfamily RedHat and systemd_available set true' do
    let(:facts) {{ 
                   :osfamily          => 'RedHat',
                   :systemd_available => true 
                }} 
    context 'with defaults for all values' do
      it { should compile.with_all_deps }
      it { should contain_file('/etc/systemd/system/my.service') }
      it { should contain_file('/etc/systemd/system/my.service').with_content("[Unit]\n\n[Service]\n\n[Install]\n") }
    end
    context 'with everything set to something different' do
      let(:params) {{ 
         :execstart     => 'doit' ,
         :servicename   => 'specified',
         :description   => 'My Service',
         :execstartpre  => 'eXecstartpre',
         :execstop      => 'eXecstop',
         :wantedby      => ['a','b','c']
      }}
      it { should contain_file('/etc/systemd/system/specified.service').with_content(/^ExecStart=doit$/) }
      it { should contain_file('/etc/systemd/system/specified.service').with_content(/^Description=My Service$/) }
      it { should contain_file('/etc/systemd/system/specified.service').with_content(/^ExecStartPre=eXecstartpre$/) }
      it { should contain_file('/etc/systemd/system/specified.service').with_content(/^ExecStop=eXecstop$/) }  
      it { should contain_file('/etc/systemd/system/specified.service').with_content(/^WantedBy=a b c$/) }  
    end
  end
end

