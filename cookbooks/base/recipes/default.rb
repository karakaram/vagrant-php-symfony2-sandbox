service "iptables" do
  action [:disable, :stop]
end

execute "Install epel repository" do
  command "rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm"
  not_if "rpm -qa | grep -q 'epel-release'"
end

execute "Install rpmforge repository" do
  command "rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm"
  not_if "rpm -qa | grep -q 'rpmforge-release'"
end

execute "Install remi repository" do
  command "rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
  not_if "rpm -qa | grep -q 'remi-release'"
end

%w{git vim-enhanced}.each do |name|
  package name do
    action :install
  end
end

template "/home/vagrant/.vimrc" do
  mode 0644
  owner "vagrant"
  group "vagrant"
  source "vimrc.erb"
end

