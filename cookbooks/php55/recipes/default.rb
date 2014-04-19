# install php
%w{php php-mysqlnd php-fpm php-mbstring php-pecl-xdebug php-intl php-opcache php-pecl-apcu php-phpunit-PHPUnit}.each do |name|
  package name do
    action :install
    options "--enablerepo=remi,remi-php55"
  end
end

# config files
template "/etc/php-fpm.d/www.conf" do
  mode 0644
  source "www.conf.erb"
  notifies :restart, "service[php-fpm]"
end

template "/etc/php.ini" do
  mode 0644
  source "php.ini.erb"
  notifies :restart, "service[php-fpm]"
end

template "/etc/php.d/mbstring.ini" do
  mode 0644
  source "mbstring.ini.erb"
  notifies :restart, "service[php-fpm]"
end

template "/etc/php.d/xdebug.ini" do
  mode 0644
  source "xdebug.ini.erb"
  notifies :restart, "service[php-fpm]"
end

template "/etc/php.d/opcache.ini" do
  mode 0644
  source "opcache.ini.erb"
  notifies :restart, "service[php-fpm]"
end

template "/etc/php.d/apcu.ini" do
  mode 0644
  source "apcu.ini.erb"
  notifies :restart, "service[php-fpm]"
end

# enable php-fpm
service "php-fpm" do
  action [:enable, :start]
end

# download composer
execute "composer-install" do
  command "curl -sS https://getcomposer.org/installer | php ;mv composer.phar /usr/local/bin/composer"
  not_if { ::File.exists?("/usr/local/bin/composer") }
end
