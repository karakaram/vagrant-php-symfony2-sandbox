# remove mysql5.1
package "mysql-libs" do
  action :remove
end

execute "Install yum mysql repository" do
  command "rpm -ivh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm"
  not_if "rpm -qa | grep -q 'mysql-community-release'"
end

package "mysql-community-server" do
  action :install
end

service "mysqld" do
  action [:start, :enable]
end

template "my.cnf" do
	path "/etc/my.cnf"
	source "my.cnf.erb"
	mode 0644
	notifies :restart, 'service[mysqld]'
end


