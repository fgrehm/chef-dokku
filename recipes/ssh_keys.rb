node['dokku']['ssh_keys'].each do |user, key|
  # TODO make this into an LWRP
  bash "gitrecieve_uploadkey" do
    cwd '/home/git'
    code <<-EOT
      echo '#{key}' | gitreceive uploadkey #{user}
    EOT
  end
end
