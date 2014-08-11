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
  not_if { ::File.directory?("#{node['nginx']['document_root']}") }
end

# download PHPUnit for IDE Code Complete
# execute "download phpunit.phar for IDE code complete" do
#   user "vagrant"
#   group "vagrant"
#   command "/usr/bin/wget https://phar.phpunit.de/phpunit.phar -P #{node['nginx']['document_root']}"
#   not_if { ::File.exists?("#{node['nginx']['document_root']}/phpunit.phar") }
# end

execute "install symfony2 from composer" do
  user "vagrant"
  group "vagrant"
  command "/usr/local/bin/composer create-project symfony/framework-standard-edition #{node['nginx']['document_root']}/symfony 2.4.*"
  not_if { ::File.directory?("#{node['nginx']['document_root']}/symfony") }
end

execute "set permission on cache directory" do
  user "vagrant"
  group "vagrant"
  command <<"EOC"
    cd #{node['nginx']['document_root']}
    rm -rf symfony/app/cache/*
    chmod 775 symfony/app/cache
EOC
  not_if "test `stat -c '%a' #{node['nginx']['document_root']}/symfony/app/cache` -eq '775'"
end

execute "set permission on logs directory" do
  user "vagrant"
  group "vagrant"
  command <<"EOC"
    cd #{node['nginx']['document_root']}
    rm -rf symfony/app/logs/*
    chmod 775 symfony/app/logs
EOC
  not_if "test `stat -c '%a' #{node['nginx']['document_root']}/symfony/app/logs` -eq '775'"
end

execute "remove 127.0.0.1 from app_dev.php" do
  user "vagrant"
  group "vagrant"
  command "sed -i 's/127.0.0.1/#{node['php']['remote_host']}/' #{node['nginx']['document_root']}/symfony/web/app_dev.php"
  only_if "grep '127.0.0.1' #{node['nginx']['document_root']}/symfony/web/app_dev.php"
end

execute "set umask for app_dev.php" do
  user "vagrant"
  group "vagrant"
  command "sed -i 's#^//umask(0000)#umask(0000)#' #{node['nginx']['document_root']}/symfony/web/app_dev.php"
  only_if "grep '^//umask(0000)' #{node['nginx']['document_root']}/symfony/web/app_dev.php"
end

execute "remove 127.0.0.1 from config.php" do
  user "vagrant"
  group "vagrant"
  command "sed -i 's/127.0.0.1/#{node['php']['remote_host']}/' #{node['nginx']['document_root']}/symfony/web/config.php"
  only_if "grep '127.0.0.1' #{node['nginx']['document_root']}/symfony/web/config.php"
end

execute "set APP_KERNEL for phpunit.xml" do
  user "vagrant"
  group "vagrant"
  command <<"EOC"
    cd #{node['nginx']['document_root']}
    sed -i 's/^    <!--//' symfony/app/phpunit.xml.dist
    sed -i 's/^    -->//' symfony/app/phpunit.xml.dist
    sed -i 's%/path/to/your/app/%#{node['nginx']['document_root']}/symfony/app/%' symfony/app/phpunit.xml.dist
EOC
  only_if "grep '/path/to/your/app/' #{node['nginx']['document_root']}/symfony/app/phpunit.xml.dist"
end

# copy_symfony_cache.sh works for Symfony2-plugin
template "#{node['nginx']['document_root']}/copy_symfony_cache.sh" do
  source "copy_symfony_cache.sh.erb"
end

# Add cron
# cron "rsync cache" do
#   user "vagrant"
#   group "vagrant"
#   command "/bin/sh #{node['nginx']['document_root']}/copy_symfony_cache.sh > /dev/null" do
#   minute "10"
# end
