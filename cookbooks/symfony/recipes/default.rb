# Add to vagrant group nginx user
group "vagrant" do
  members ["vagrant","nginx"]
  action :modify
end

# Add to nginx group vagrant user
group "nginx" do
  members ["nginx","vagrant"]
  action :modify
end

# Create symfony document root
directory "#{node['nginx']['document_root']}" do
  owner 'vagrant'
  group 'vagrant'
  mode 0775
  action :create
end

# download PHPUnit for IDE Code Complete
execute "phpunit.phar-download" do
  user "vagrant"
  group "vagrant"
  command "/usr/bin/wget https://phar.phpunit.de/phpunit.phar -P #{node['nginx']['document_root']}"
  not_if { ::File.exists?("#{node['nginx']['document_root']}/phpunit.phar") }
end

# copy_symfony_cache.sh for Symfony2-plugin
template "#{node['nginx']['document_root']}/copy_symfony_cache.sh" do
  mode 0664
  owner "vagrant"
  group "vagrant"
  source "copy_symfony_cache.sh.erb"
end

# Install symfony from shell script
template "#{node['nginx']['document_root']}/install_symfony.sh" do
  mode 0664
  owner "vagrant"
  group "vagrant"
  source "install_symfony.sh.erb"
end

execute "symfony2-install" do
  user "vagrant"
  group "vagrant"
  command "/bin/sh #{node['nginx']['document_root']}/install_symfony.sh"
  not_if { ::File.directory?("#{node['nginx']['document_root']}/symfony") }
end

# Add cron
# cron "rsync cache" do
#   user "vagrant"
#   group "vagrant"
#   command "/bin/sh #{node['nginx']['document_root']}/copy_symfony_cache.sh > /dev/null" do
#   minute "10"
# end
