package "samba" do
  action :install
end

template "/etc/samba/smb.conf" do
  mode 0644
  source "smb.conf.erb"
  notifies :restart, "service[smb]"
end

if node['samba']['enable'] == "1" then
  service "smb" do
    action [:enable, :start]
  end
else
  service "smb" do
    action [:disable, :stop]
  end
end
