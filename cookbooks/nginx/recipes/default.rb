# Install nginx
package "nginx" do
  action :install
  options "--enablerepo=remi"
end

# config file
template "/etc/nginx/conf.d/default.conf" do
  mode 0644
  source "default.conf.erb"
  notifies :restart, "service[nginx]"
end

# enable nginx
service "nginx" do
  action [:enable, :start]
end

