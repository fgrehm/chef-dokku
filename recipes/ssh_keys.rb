node['dokku']['ssh_keys'].each do |user, key|
  # TODO make this into an LWRP
  bash "sshcommand_acl-add_key" do
    cwd '/home/git'
    code <<-EOT
      echo '#{key}' | sshcommand acl-add dokku #{user}
    EOT
  end
end
