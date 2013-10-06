node['dokku']['ssh_keys'].each do |user, key|
  # TODO make this into an LWRP
  bash "gitrecieve_upload-key" do
    cwd '/home/git'
    code <<-EOT
      echo '#{key}' | gitreceive upload-key #{user}
    EOT
  end
end
